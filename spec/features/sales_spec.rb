# frozen_string_literal: true

require 'rails_helper'

describe 'navigation' do
  let(:user) { FactoryBot.create(:user) }

  let(:sale) do
    Sale.create(amount: 10, description: 'Something', client: 'Someone', user_id: user.id)
  end

  before do
    login_as(user, scope: :user)
  end

  describe 'index' do
    before do
      visit sales_path
    end

    it 'has a sales page' do
      expect(page.status_code).to eq(200)
    end

    it 'has a title of Sales' do
      expect(page).to have_content(/Sales/)
    end

    it 'has a list of sales' do
      sale1 = FactoryBot.build_stubbed(:sale)
      sale2 = FactoryBot.build_stubbed(:second_sale)

      visit sales_path

      expect(page).to have_content(/Sale|second/)
    end

    it 'has a scope so that only sales creators can see their sales' do
      other_user = User.create(email: 'nonauth@example.com', password: 'asdfasdf', password_confirmation: 'asdfasdf')

      product_from_other_user = Sale.create(amount: 12, description: "This product shouldn't be seen", client: 'One', user_id: other_user.id)

      visit sales_path

      expect(page).to_not have_content(/This product shouldn't be seen/)
    end

    it 'has total of all the sales' do
      sale1 = FactoryBot.create(:sale, user_id: user.id)
      sale2 = FactoryBot.create(:second_sale, user_id: user.id)

      visit sales_path

      expect(page).to have_content(/Total sales: 21/)
    end

    it 'has a link from the sales page' do
      click_on 'Create a new sale'
      expect(current_path).to eq(new_sale_path)
    end
  end

  describe 'creation' do
    before do
      client = FactoryBot.create(:client, user_id: user.id)
      visit new_sale_path
    end

    it 'has a new form that can be reached' do
      expect(page.status_code).to eq(200)
    end

    it 'has a way to create a sale' do
      select 'Aarya', from: :sale_client, visible: false
      fill_in 'sale[amount]', with: 10
      fill_in 'sale[description]', with: 'Anything'

      expect { click_on 'Save' }.to change(Sale, :count).by(1)
    end

    it 'will have a user associated with it' do
      select 'Aarya', from: :sale_client, visible: false
      fill_in 'sale[amount]', with: 11
      fill_in 'sale[description]', with: 'User associated'
      click_on 'Save'

      expect(User.last.sales.last.description).to eq('User associated')
    end
  end

  describe 'edit' do
    it 'can be edited' do
      visit edit_sale_path(sale)

      fill_in 'sale[amount]', with: 11
      fill_in 'sale[description]', with: 'Edited sale'

      click_on 'Save'

      expect(page).to have_content(/Edited sale/)
    end
  end

  describe 'delete' do
    it 'can be deleted' do
      logout(:user)

      delete_user = FactoryBot.create(:user)
      login_as(delete_user, scope: :user)

      sale_to_delete = Sale.create(amount: 15, description: 'Kinda expensive', client: 'Anyone', user_id: delete_user.id)

      visit sales_path

      click_link("delete_sale_#{sale_to_delete.id}_from_index")

      expect(page.status_code).to eq(200)
    end
  end
end
