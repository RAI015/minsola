module ApplicationHelper
  WEBSITE_NAME = 'Every-Weather'.freeze
  WEATHERS = %w[快晴 晴れ 薄曇り 曇り 小雨 雨 豪雨 雷 みぞれ 雪 大雪 あられ ひょう 霧 霧雨 砂あらし].freeze
  FEELINGS = %w[うだる暑さ 暑い 暖かい ちょうどいい 肌寒い 凍えるほど寒い あてはまらない].freeze
  EXPECTATIONS = %w[今と変化なさそう 回復しそう 下り坂になりそう].freeze

  # Search用
  CLMN_CAPTION = 'caption'.freeze
  CLMN_PREFECTURE = 'prefecture_id'.freeze
  CLMN_CITY = 'city_id'.freeze
  CLMN_WEATHER = 'weather'.freeze

  def full_title(page_title = '')
    base_title = WEBSITE_NAME
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def header_link_item(name, path)
    class_name = 'nav-item'
    class_name << ' active' if current_page?(path)

    content_tag :li, class: class_name do
      link_to name, path, class: 'nav-link'
    end
  end

  def nav_link_add_active(name, path)
    class_name = 'nav-link nav-item'
    class_name << ' active' if current_page?(path)

    link_to name, path, class: class_name
  end

  def set_address(prefecture, city)
    "#{prefecture} #{city}"
  end
end
