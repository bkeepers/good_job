# frozen_string_literal: true
module GoodJob
  module ApplicationHelper
    def format_duration(sec)
      return unless sec

      if sec < 1
        format "%{ms}dms", ms: sec * 1000
      elsif sec < 10
        format "%{sec}.2fs", sec: sec
      elsif sec < 60
        format "%{sec}ds", sec: sec
      elsif sec < 3600
        format "%{min}dm%{sec}ds", min: sec / 60, sec: sec % 60
      else
        format "%{hour}dh%{min}dm", hour: sec / 3600, min: (sec % 3600) / 60
      end
    end

    def relative_time(timestamp, **args)
      text = timestamp.future? ? "in #{time_ago_in_words(timestamp, **args)}" : "#{time_ago_in_words(timestamp, **args)} ago"
      tag.time(text, datetime: timestamp, title: timestamp)
    end

    STATUS_ICONS = {
      discarded: "exclamation",
      finished: "check",
      queued: "clock",
      retried: "arrow_clockwise",
      running: "play",
      scheduled: "clock",
    }.freeze

    STATUS_COLOR = {
      discarded: "danger",
      finished: "success",
      queued: "secondary",
      retried: "secondary",
      running: "primary",
      scheduled: "secondary",
    }.freeze

    def status_badge(status)
      content_tag :span, status_icon(status, class: "text-white") + status.to_s.titleize,
                  class: "badge rounded-pill bg-#{STATUS_COLOR.fetch(status)} d-inline-flex gap-2 ps-1 pe-3 align-items-center"
    end

    def status_icon(status, **options)
      options[:class] ||= "text-#{STATUS_COLOR.fetch(status)}"
      icon = render_icon STATUS_ICONS.fetch(status)
      content_tag :span, icon, **options
    end

    def render_icon(name)
      # workaround to render svg icons without all of the log messages
      partial = lookup_context.find_template("good_job/shared/icons/#{name}", [], true)
      partial.render(self, {})
    end
  end
end
