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

  describe 'set_address' do
    it '都道府県と市区町村を渡すと、「都道府県 市区町村」を返すこと' do
      prefecture = '東京都'
      city = '渋谷区'
      expect(set_address(prefecture, city)).to eq '東京都' + ' ' + '渋谷区'
    end
  end
end
