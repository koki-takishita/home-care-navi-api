module OfficeParamsSupport
  OFFICE_ATTRIBUTES = {
    name: 'ケアサービス佐渡',
    title: '日々の暮らしをサポートします',
    flags: 8, # 土日休み app/models/office.rb 64-70行目参照
    business_day_detail: '第３水曜日は休みです',
    address: '新潟県佐渡市秋津415-9',
    post_code: '952-0021',
    fax_number: '026-8773-8873'
  }.freeze

  DETAIL_ATTRIBUTES = {
    detail: 'ケアサービス佐渡が最高の介護施設である3つの理由',
    service_type: '介護付きホーム(サービス付き高齢者向け住宅 特定施設)',
    open_date: '2011年3月1日',
    rooms: 30,
    requirement: '満60歳以上の方、入居時自立・要支援・要介護',
    facility: 'エントランス、食堂兼機能訓練室、個浴、大浴場、特殊浴槽、和室、談話室、シアタールーム、屋上庭園',
    management: '株式会社ユニマット リタイアメント・コミュニティ',
    link: 'https://prum.jp/',
    comment_1: '大浴場の画像です',
    comment_2: 'ゴルフ大会の様子です'
  }.freeze

  # office_params(offices = {}, detail = {})
  #
  # 属性を指定しない場合
  # => office_params()
  #
  # officeの属性の指定の仕方
  # => office_params({name: '株式会社prum', title: '日本一エンジニアが成長できる環境を目指す', ...})
  #
  # detailの属性の指定の仕方
  # => office_params({...}, {detail: '事業形態: SES・受託開発', rooms: 54, ...})
  #
  def office_params(offices = {}, details = {})
    office_attributes, detail_attributes = set_attributes(offices, details)
    build_params(office_attributes, detail_attributes)
  end

  private

    def set_attributes(offices, details)
      office_attributes = set_obj_attributes(obj: offices, constant: OFFICE_ATTRIBUTES)
      detail_attributes = set_obj_attributes(obj: details, constant: DETAIL_ATTRIBUTES)
      [office_attributes, detail_attributes]
    end

    def build_params(office_attributes, detail_attributes)
      params = {}
      office = { office: office_attributes.to_json }
      detail = { detail: detail_attributes.to_json }
      params.merge(office, detail)
    end

  # office・detailのparamsをセットする
  #
  #
  # 戻り値 hash
  # {
  #   name: 'ケアサービス佐渡',
  #   title: 'ケアサービス佐渡が最高の介護施設である3つの理由',
  #   flags: 8,
  #   .
  #   .
  #   .
  # }
    def set_obj_attributes(obj:, constant:)
      attributes = {}
      constant.each { |key, value|
        item = obj[key].nil? ? value : obj[key]
        attributes[key] = item
      }
      attributes
    end
end

RSpec.configure do |config|
  # 下記をスペックの中で呼び出す
  # office_params(offices = {}, details = {})
  #
  # 使用例 引数指定しない
  # post api_specialists_offices_path, params: office_params(), headers: auth_params
  #
  # 引数指定 officeの属性を指定
  # post api_specialists_offices_path, params: office_params({name: 'ケアマーク新潟'}), headers: auth_params
  #
  # 引数指定 office, detail両方指定
  # post api_specialists_offices_path, params: office_params({name: 'ケアパークPRUM'}, {detail: '佐渡島という集中できる環境整備'}), headers: auth_params
  config.include OfficeParamsSupport
end
