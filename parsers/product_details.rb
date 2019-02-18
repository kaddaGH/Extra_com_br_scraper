require 'securerandom'
data = JSON.parse(content)

product = data['content']
name= product['name']

pack = name[/(\d+)(?=\s+Unidades)/].to_i rescue  nil

brand = (product['name'].downcase.include?'red bull')? 'Red Bull':nil
if brand.nil?
  brand =product['name'][/\s[A-Z\s]{3,}\s/]
end
desciption = product['shortDescription'].gsub(/<[^<>]+>/,' ').gsub(/[,\s\n]/,' ').strip rescue ""

availability = product['stock'] == true ? '1' : ''
if pack.nil? or pack==0
  pack = product['totalQuantity'].to_i == 0 ? '1' : product['totalQuantity'].to_i
end

promotion_text  =product['productPromotion']['promotionPercentOff'].to_s+"% OFF" rescue ""

regexps = [
    /(\d*[\.,]?\d+)\s?([Ff][Ll]\.?\s?[Oo][Zz])/,
    /(\d*[\.,]?\d+)\s?([Oo][Zz])/,
    /(\d*[\.,]?\d+)\s?([Ff][Oo])/,
    /(\d*[\.,]?\d+)\s?([Ee][Aa])/,
    /(\d*[\.,]?\d+)\s?([Ff][Zz])/,
    /(\d*[\.,]?\d+)\s?(Fluid Ounces?)/,
    /(\d*[\.,]?\d+)\s?([Oo]unce)/,
    /(\d*[\.,]?\d+)\s?([Mm][Ll])/,
    /(\d*[\.,]?\d+)\s?([Cc][Ll])/,
    /(\d*[\.,]?\d+)\s?([Ll])/,
    /(\d*[\.,]?\d+)\s?([Gg])/,
    /(\d*[\.,]?\d+)\s?([Ll]itre)/,
    /(\d*[\.,]?\d+)\s?([Ss]ervings)/,
    /(\d*[\.,]?\d+)\s?([Pp]acket\(?s?\)?)/,
    /(\d*[\.,]?\d+)\s?([Cc]apsules)/,
    /(\d*[\.,]?\d+)\s?([Tt]ablets)/,
    /(\d*[\.,]?\d+)\s?([Tt]ubes)/,
    /(\d*[\.,]?\d+)\s?([Cc]hews)/,
    /(\d*[\.,]?\d+)\s?([Mm]illiliter)/i,
]
regexps.find {|regexp| name =~ regexp}
item_size = $1
uom = $2


product_details = {
    # - - - - - - - - - - -
    RETAILER_ID: '115',
    RETAILER_NAME: 'deliveryextra',
    GEOGRAPHY_NAME: 'BR',
    # - - - - - - - - - - -
    SCRAPE_INPUT_TYPE: page['vars']['input_type'],
    SCRAPE_INPUT_SEARCH_TERM: page['vars']['search_term'],
    SCRAPE_INPUT_CATEGORY: page['vars']['input_type'] == 'taxonomy' ? 'Energéticos e isotônicos' : '-',
    SCRAPE_URL_NBR_PRODUCTS: page['vars']['scrape_url_nbr_products'],
    # - - - - - - - - - - -
    SCRAPE_URL_NBR_PROD_PG1:page['vars']['nbr_products_pg1'],
    # - - - - - - - - - - -
    PRODUCT_BRAND: brand,
    PRODUCT_RANK: page['vars']['rank'],
    PRODUCT_PAGE: page['vars']['page'],
    PRODUCT_ID: product['id'],
    PRODUCT_NAME: product['name'],
    PRODUCT_DESCRIPTION: desciption,
    PRODUCT_MAIN_IMAGE_URL: "https://www.deliveryextra.com.br"+product['thumbPath'].gsub(/50x50/,'200x200'),
    PRODUCT_ITEM_SIZE: item_size,
    PRODUCT_ITEM_SIZE_UOM: uom,
    PRODUCT_ITEM_QTY_IN_PACK: pack,
    SALES_PRICE: product['currentPrice'],
    IS_AVAILABLE: availability,
    PROMOTION_TEXT: promotion_text,
}

pages << {
    page_type: 'product_reviews',
    method: 'GET',
    url: "https://api.gpa.digital/ex/products/#{product['id']}/review?uid=#{SecureRandom.uuid}",
    vars: {
        'product_details' => product_details
    }


}