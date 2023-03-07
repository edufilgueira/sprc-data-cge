require 'rails_helper'

describe Integration::Constructions::Dae do
  subject(:dae) { build(:integration_constructions_dae) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_constructions_dae, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:id_obra).of_type(:integer) }
      it { is_expected.to have_db_column(:codigo_obra).of_type(:string) }
      it { is_expected.to have_db_column(:contratada).of_type(:string) }
      it { is_expected.to have_db_column(:data_fim_previsto).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_inicio).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_ordem_servico).of_type(:datetime) }
      it { is_expected.to have_db_column(:descricao).of_type(:string) }
      it { is_expected.to have_db_column(:dias_aditivado).of_type(:integer) }
      it { is_expected.to have_db_column(:latitude).of_type(:string) }
      it { is_expected.to have_db_column(:longitude).of_type(:string) }
      it { is_expected.to have_db_column(:municipio).of_type(:string) }
      it { is_expected.to have_db_column(:numero_licitacao).of_type(:string) }
      it { is_expected.to have_db_column(:numero_ordem_servico).of_type(:string) }
      it { is_expected.to have_db_column(:numero_sacc).of_type(:string) }
      it { is_expected.to have_db_column(:percentual_executado).of_type(:decimal) }
      it { is_expected.to have_db_column(:prazo_inicial).of_type(:integer) }
      it { is_expected.to have_db_column(:secretaria).of_type(:string) }
      it { is_expected.to have_db_column(:status).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_contrato).of_type(:string) }
      it { is_expected.to have_db_column(:valor).of_type(:decimal) }


      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:id_obra) }
      it { is_expected.to have_db_index(:codigo_obra) }
      it { is_expected.to have_db_index(:contratada) }
      it { is_expected.to have_db_index(:municipio) }
      it { is_expected.to have_db_index(:secretaria) }
      it { is_expected.to have_db_index(:status) }
      it { is_expected.to have_db_index(:dae_status) }
    end
  end


  describe 'associations' do
    it do
      is_expected.to belong_to(:organ)
      .class_name('Integration::Supports::Organ')
    end

    it do
      is_expected.to have_many(:measurements)
      .class_name('Integration::Constructions::Dae::Measurement')
      .dependent(:destroy)
    end

    it do
      is_expected.to have_many(:photos)
      .class_name('Integration::Constructions::Dae::Photo')
      .dependent(:destroy)
    end

    it do
      is_expected.to have_one(:utils_data_change).class_name('Integration::Utils::DataChange')
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:data_changes).to(:utils_data_change).with_arguments(allow_nil: true) }
    it { is_expected.to delegate_method(:resource_status).to(:utils_data_change).with_arguments(allow_nil: true) }
  end


  describe 'enums' do
    it 'dae_status' do
      statuses = [
        :waiting,
        :canceled,
        :done,
        :in_progress,
        :finished,
        :paused
      ]

      is_expected.to define_enum_for(:dae_status).with(statuses)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:id_obra) }
    it { is_expected.to validate_presence_of(:descricao) }
  end

  describe 'callbacks' do
    describe 'create_last_changes' do
      it 'change prazo_inicial' do
        changes_notificables = { 'prazo_inicial'=>[180, 2] }

        dae.save

        dae.update(prazo_inicial: 2)

        expect(dae.data_changes).to eq(changes_notificables)
        expect(dae.resource_status).to eq('updated_resource_notificable')
      end

      it 'dont change prazo_inicial' do
        dae.save

        dae.update(prazo_inicial: 180)

        expect(dae.data_changes).to eq(nil)
        expect(dae.resource_status).to eq('new_resource_notificable')
      end

      it 'new record' do
        dae.save

        expect(dae.data_changes).to eq(nil)
        expect(dae.resource_status).to eq('new_resource_notificable')
      end

      it 'data_fim_previsto not changed' do
        dae.save

        dae.update(data_fim_previsto: '28/09/2017')

        expect(dae.data_changes).to eq(nil)

        expect(dae.resource_status).to eq('new_resource_notificable')
      end

      it 'data_fim_previsto changed' do
        dae.save

        dae.update(data_fim_previsto: '29/09/2017')

        expect(dae.data_changes).to_not eq({})
        expect(dae.resource_status).to eq('updated_resource_notificable')
      end

      it 'other description doesnt call service' do
        dae.save

        dae.update(descricao: 'other description doesnt call notifier')

        expect(dae.resource_status).to eq('new_resource_notificable')
      end

      it 'overide utils_data_change' do
        changes_notificables = { 'prazo_inicial'=>[180, 2] }
        another_changes_notificables = { 'prazo_inicial'=>[2, 3] }

        dae.save
        dae.update(prazo_inicial: 2)

        expect(dae.data_changes).to eq(changes_notificables)
        expect(dae.resource_status).to eq('updated_resource_notificable')

        dae = Integration::Constructions::Dae.last

        dae.update(prazo_inicial: 3)

        expect(dae.data_changes).to eq(another_changes_notificables)
        expect(dae.resource_status).to eq('updated_resource_notificable')
      end
    end
  end

  describe 'helpers' do
    it 'title' do
      expected = "#{dae.codigo_obra.to_s} - #{dae.descricao.truncate(30)}"

      expect(dae.title).to eq(expected)
    end
  end
end
