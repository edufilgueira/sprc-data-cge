class Integration::Servers::ProceedType < ApplicationDataRecord

  validates :cod_provento,
    :dsc_provento,
    :dsc_tipo,
    presence: true

  validates :cod_provento, uniqueness: { scope: :origin,
    message: "should happen once per origin" }


  enum origin: { seplag: 0, metrofor: 1 }


end
