require 'spec_helper'
require 'ostruct'
require 'marketplace/setup'

describe Marketplace::Setup do
  subject { described_class.new(options, omnibus_ctl) }

  let(:options) { OpenStruct.new }
  let(:omnibus_ctl) { double('OmnibusCtl') }
  let(:current_hostname) { 'current.hostname.com' }
  let(:json) { { 'chef-marketplace' => { 'role' => 'tofu' } }.to_json }

  before do
    # Stub out the role
    allow(File)
      .to receive(:exist?)
      .with('/etc/chef-marketplace/chef-marketplace-running.json')
      .and_return(true)
    allow(IO)
      .to receive(:read)
      .with('/etc/chef-marketplace/chef-marketplace-running.json')
      .and_return(json)
    allow(options).to receive(:preconfigure).and_return(false)
  end

  describe '#setup' do
    before do
      allow(subject).to receive(:role).and_return(role)
      allow(subject).to receive(:redirect_user).and_return(true)
      allow(subject).to receive(:reconfigure).and_return(true)
      allow(subject).to receive(:update_software).and_return(true)
      allow(subject).to receive(:validate_options).and_return(true)
      allow(subject).to receive(:agree_to_eula).and_return(true)
      allow(subject).to receive(:validate_payment).and_return(true)
      allow(subject).to receive(:create_server_user).and_return(true)
      allow(subject).to receive(:create_server_org).and_return(true)
      allow(subject).to receive(:create_compliance_user).and_return(true)
      allow(subject).to receive(:register_node).and_return(true)
      allow(subject).to receive(:ask_for_node_registration).and_return(true)
      allow(subject).to receive(:wait_for_cloud_init_preconfigure).and_return(true)
      allow(subject).to receive(:create_default_users).and_return(true)
    end

    context 'when the server has not been preconfigured' do
      before { allow(subject).to receive(:preconfigured?).and_return(false) }

      context 'when the role is server' do
        let(:role) { 'server' }

        it 'sets up the chef server' do
          expect(subject).to receive(:reconfigure).with(:server).once
          expect(subject).to receive(:reconfigure).with(:manage).once
          expect(subject).to receive(:reconfigure).with(:reporting).once
          expect(subject).to_not receive(:reconfigure).with(:compliance)
          expect(subject).to_not receive(:reconfigure).with(:analytics)

          subject.setup
        end
      end

      context 'when the role is analytics' do
        let(:role) { 'analytics' }

        it 'sets up chef analytics' do
          expect(subject).to receive(:reconfigure).with(:analytics).once
          expect(subject).to_not receive(:reconfigure).with(:server)
          expect(subject).to_not receive(:reconfigure).with(:manage)
          expect(subject).to_not receive(:reconfigure).with(:reporting)
          expect(subject).to_not receive(:reconfigure).with(:compliance)

          subject.setup
        end
      end

      context 'when the role is aio' do
        let(:role) { 'aio' }

        it 'sets up chef server and analytics' do
          expect(subject).to receive(:reconfigure).with(:server).once
          expect(subject).to receive(:reconfigure).with(:manage).once
          expect(subject).to receive(:reconfigure).with(:reporting).once
          expect(subject).to receive(:reconfigure).with(:analytics).once
          expect(subject).to_not receive(:reconfigure).with(:compliance)

          subject.setup
        end
      end
    end

    context 'when the server has been preconfigured' do
      before { allow(subject).to receive(:preconfigured?).and_return(true) }

      context 'when the role is server' do
        let(:role) { 'server' }

        it 'does not set up the chef server' do
          expect(subject).to_not receive(:reconfigure).with(:server)
          expect(subject).to_not receive(:reconfigure).with(:manage)
          expect(subject).to_not receive(:reconfigure).with(:reporting)
          expect(subject).to_not receive(:reconfigure).with(:compliance)
          expect(subject).to_not receive(:reconfigure).with(:analytics)

          subject.setup
        end
      end

      context 'when the role is analytics' do
        let(:role) { 'analytics' }

        it 'does not set up chef analytics' do
          expect(subject).to_not receive(:reconfigure).with(:analytics)
          expect(subject).to_not receive(:reconfigure).with(:server)
          expect(subject).to_not receive(:reconfigure).with(:manage)
          expect(subject).to_not receive(:reconfigure).with(:reporting)
          expect(subject).to_not receive(:reconfigure).with(:compliance)

          subject.setup
        end
      end

      context 'when the role is aio' do
        let(:role) { 'aio' }

        it 'does not set up chef server and analytics' do
          expect(subject).to_not receive(:reconfigure).with(:server)
          expect(subject).to_not receive(:reconfigure).with(:manage)
          expect(subject).to_not receive(:reconfigure).with(:reporting)
          expect(subject).to_not receive(:reconfigure).with(:analytics)
          expect(subject).to_not receive(:reconfigure).with(:compliance)

          subject.setup
        end
      end
    end

    context 'when the preconfigure option is passed' do
      let(:role) { 'aio' }

      before { allow(options).to receive(:preconfigure).and_return(true) }

      it 'only preconfigures the software' do
        expect(subject).to receive(:configure_software).once
        expect(subject).to_not receive(:create_default_users)
        expect(subject).to_not receive(:update_software)
        expect(subject).to_not receive(:agree_to_eula)
        expect(subject).to_not receive(:redirect_user)

        subject.setup
      end
    end
  end

  describe '#role' do
    context 'when chef-marketplace has been configured' do
      it 'loads the role from the running json' do
        expect(subject.send(:role)).to eq('tofu')
      end
    end

    context 'when chef marketplace has not been configured' do
      before do
        allow(File)
          .to receive(:exist?)
          .with('/etc/chef-marketplace/chef-marketplace-running.json')
          .and_return(false)
      end

      it 'raises a system exit' do
        expect { subject.send(:role) }
          .to raise_error(SystemExit) { |e| expect(e.status).to eq(1) }
      end
    end
  end
end
