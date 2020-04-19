require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe 'full_title' do
    it 'ページタイトルが無い場合、サイト名だけを返すこと' do
      expect(full_title).to eq 'MinSola'
    end

    it 'ページタイトルがある場合、ページタイトル＋サイト名を返すこと' do
      expect(full_title('Home')).to eq 'Home' + ' | ' + 'MinSola'
    end
  end

  describe 'header_link_item' do
    xit 'pathが現在のページだった場合、class: activeを付けてaタグを返すこと' do
      a = header_link_item('index', root_path)
      binding.pry
    end

    xit 'pathが現在のページでなかった場合、class: activeを付けてaタグを返すこと' do

    end
  end

  describe 'nav_link_add_active' do
    xit 'pathが現在のページだった場合、class: activeを付けてaタグを返すこと' do

    end

    xit 'pathが現在のページでなかった場合、class: activeを付けてaタグを返すこと' do

    end
  end

  describe 'set_address' do
    it '都道府県と市区町村を渡すと、「都道府県 市区町村」を返すこと' do
      prefecture = FactoryBot.create(:prefecture)
      city = FactoryBot.create(:city)
      expect(set_address(prefecture.name, city.name)).to eq "#{prefecture.name} #{city.name}"
    end
  end
end
