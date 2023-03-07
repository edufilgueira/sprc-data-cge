class CreateGasVoucher < ActiveRecord::Migration[5.0]
  def change
  	#REGIÃO;MUNICÍPIO;NIS;CPF;BENEFICIÁRIO;LOTE 01;LOTE 02;LOTE 03
    create_table :gas_vouchers do |t|
    	t.string :region
    	t.string :city
    	t.string :nis
    	t.string :cpf
    	t.string :name
    	t.string :lot_1
    	t.string :lot_2
    	t.string :lot_3
 			t.timestamps
    end

    add_index :gas_vouchers, :cpf
  end
end
	