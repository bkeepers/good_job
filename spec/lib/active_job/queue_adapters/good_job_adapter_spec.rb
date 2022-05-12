# frozen_string_literal: true
require 'rails_helper'

describe ActiveJob::QueueAdapters::GoodJobAdapter do
  it 'inherits from GoodJob::Adapter' do
    expect(described_class).to be < GoodJob::Adapter
  end

  it 'allows usage of ActiveJob symbol' do
    ActiveJob::Base.queue_adapter = :good_job
    expect(ActiveJob::Base.queue_adapter).to be_a described_class
  end

  describe '#initialize' do
    before { allow(Rails.env).to receive(:test?).and_return(false) }

    context 'when in development environment' do
      before do
        allow(Rails.env).to receive(:development?).and_return(true)
        stub_const("Rails::Server", Class.new)
      end

      it 'runs async' do
        adapter = described_class.new
        expect(adapter.execute_async?).to be true
      end
    end

    context 'when in test environment' do
      before { allow(Rails.env).to receive(:test?).and_return(true) }

      it 'runs inline' do
        adapter = described_class.new
        expect(adapter.execute_inline?).to be true
      end
    end

    context 'when in production environment' do
      before { allow(Rails.env).to receive(:production?).and_return(true) }

      it 'runs in normal mode' do
        adapter = described_class.new
        expect(adapter.execute_inline?).to be false
      end
    end
  end
end
