require 'rails_helper'

RSpec.describe 'Api::Customer::Offices', type: :request do
  describe 'エリア検索機能' do
    before do
      # 東京都千代田区15件分作成
      (1..3).each { |n|
        create(:office, address: "東京都千代田区丸の内#{n}丁目")
        create(:office, address: "東京都千代田区岩本町#{n}丁目")
        create(:office, address: "東京都千代田区一ツ橋#{n}丁目")
        create(:office, address: "東京都千代田区神田神保町#{n}丁目")
        create(:office, address: "東京都千代田区鍛冶町#{n}丁目")
      }

      # 北海道旭川市5件分作成
      (1..2).each { |n|
        create(:office, address: "北海道旭川市秋月#{n}条")
        create(:office, address: "北海道旭川市神楽岡#{n}条")
      }
      create(:office, address: '北海道旭川市江丹別町')

      # 新潟県佐渡市5件分作成
      create(:office, address: '新潟県佐渡市両津夷')
      create(:office, address: '新潟県佐渡市金井町大字千種')
      create(:office, address: '新潟県佐渡市秋津')
      create(:office, address: '新潟県佐渡市相川三町目')
      create(:office, address: '新潟県佐渡市小木町')

      # 沖縄那覇市5件分作成
      create(:office, address: '沖縄県那覇市垣花町')
      create(:office, address: '沖縄県那覇市首里赤田町')
      create(:office, address: '沖縄県那覇市住吉町')
      create(:office, address: '沖縄県那覇市仲井真')
      create(:office, address: '沖縄県那覇市繁多川')
    end

    context '登録済みデータ' do
      context '東京都千代田区' do
        it '取得できるのは最大10件' do
          get '/api/offices', params: { prefecture: '東京都', cities: '千代田区' }
          # response.bodyがstringのため変換している
          expect(JSON.parse(response.body).count).to eq 10
        end

        # pageに値を指定するとオフセットできる
        #
        # page: 0  0〜10 最初の10件
        # page: 1 11〜20 10件分オフセット
        # page: 2 21〜30 20件分オフセット
        context 'オフセット' do
          it '5件取得できる' do
            get '/api/offices', params: { prefecture: '東京都', cities: '千代田区', page: 1 }
            expect(JSON.parse(response.body).count).to eq 5
          end

          it 'ヒットしない' do
            get '/api/offices', params: { prefecture: '東京都', cities: '千代田区', page: 2 }
            expect(JSON.parse(response.body).count).to eq 0
          end
        end
      end

      context '新潟県佐渡市' do
        it '5件取得できる' do
          get '/api/offices', params: { prefecture: '新潟県', cities: '佐渡市' }
          expect(JSON.parse(response.body).count).to eq 5
        end
      end

      context '北海道旭川市' do
        it '5件取得できる' do
          get '/api/offices', params: { prefecture: '北海道', cities: '旭川市' }
          expect(JSON.parse(response.body).count).to eq 5
        end
      end

      context '沖縄県那覇市' do
        it '5件取得できる' do
          get '/api/offices', params: { prefecture: '沖縄県', cities: '那覇市' }
          expect(JSON.parse(response.body).count).to eq 5
        end
      end

      context 'キーワード検索' do
        context '東京都' do
          it '取得できるのは最大10件' do
            get '/api/offices', params: { keywords: '東京都' }
            expect(JSON.parse(response.body).count).to eq 10
          end
        end

        context '千代田区' do
          it '取得できるのは最大10件' do
            get '/api/offices', params: { keywords: '千代田区' }
            expect(JSON.parse(response.body).count).to eq 10
          end
        end

        context '丸の内' do
          it '3件取得できる' do
            get '/api/offices', params: { keywords: '丸の内' }
            expect(JSON.parse(response.body).count).to eq 3
          end
        end

        context '丸の内1丁目' do
          it '1件取得できる' do
            get '/api/offices', params: { keywords: '丸の内1丁目' }
            expect(JSON.parse(response.body).count).to eq 1
          end
        end

        context '東京都千代田区丸の内のオフィスの郵便番号' do
          it '1件取得できる' do
            office = Office.eager_load(:thanks,
                                       :office_detail,
                                       :staffs, :bookmarks)
                           .where.like(address: '%丸の内1丁目%').first
            get '/api/offices', params: { postCodes: office.post_code.delete('-') }
            expect(JSON.parse(response.body).count).to eq 1
          end
        end

        context '東京都千代田区丸の内のオフィスの住所と郵便番号' do
          it '1件取得できる' do
            office = Office.eager_load(:thanks,
                                       :office_detail,
                                       :staffs, :bookmarks)
                           .where.like(address: '%丸の内1丁目%').first
            get '/api/offices', params: { keywords: office.address, postCodes: office.post_code.delete('-') }
            expect(JSON.parse(response.body).count).to eq 1
          end
        end
      end
    end

    context '登録されていないデータ' do
      context '静岡県浜松市' do
        it 'ヒットしない' do
          get '/api/offices', params: { prefecture: '静岡県', cities: '浜松市' }
          expect(JSON.parse(response.body).count).to eq 0
        end
      end

      context '東京都港区' do
        it 'ヒットしない' do
          get '/api/offices', params: { prefecture: '東京都', cities: '港区' }
          expect(JSON.parse(response.body).count).to eq 0
        end
      end

      context '新潟県新潟市' do
        it 'ヒットしない' do
          get '/api/offices', params: { prefecture: '新潟県', cities: '新潟市' }
          expect(JSON.parse(response.body).count).to eq 0
        end
      end

      context '北海道札幌市' do
        it 'ヒットしない' do
          get '/api/offices', params: { prefecture: '北海道', cities: '札幌市' }
          expect(JSON.parse(response.body).count).to eq 0
        end
      end

      context '沖縄県石垣市' do
        it 'ヒットしない' do
          get '/api/offices', params: { prefecture: '沖縄県', cities: '石垣市' }
          expect(JSON.parse(response.body).count).to eq 0
        end
      end

      context 'キーワード検索' do
        context '静岡県' do
          it 'ヒットしない' do
            get '/api/offices', params: { keywords: '静岡県' }
            expect(JSON.parse(response.body).count).to eq 0
          end
        end

        context '浜松市' do
          it 'ヒットしない' do
            get '/api/offices', params: { keywords: '浜松市' }
            expect(JSON.parse(response.body).count).to eq 0
          end
        end
      end
    end
  end
end
