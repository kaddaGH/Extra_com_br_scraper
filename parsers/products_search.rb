data = JSON.parse(content)

data = data['content']
scrape_url_nbr_products = data['totalElements'].to_i
current_page = data['number'].to_i
page_size = data['size'].to_i
number_of_pages = data['totalPages'].to_i
products = data['products']


# if ot's first page , generate pagination
if current_page == 0 and number_of_pages > 1 and 3>4
  nbr_products_pg1 = products.length
  step_page = 1
  while step_page < number_of_pages
    pages << {
        page_type: 'products_search',
        method: 'GET',
        url: page['url'].gsub(/page=0/, "page=#{step_page}"),
        vars: {
            'input_type' => page['vars']['input_type'],
            'search_term' => page['vars']['search_term'],
            'page' => step_page,
            'nbr_products_pg1' => nbr_products_pg1
        }
    }

    step_page = step_page + 1


  end
elsif current_page == 0 and number_of_pages == 1
  nbr_products_pg1 = products.length
else
  nbr_products_pg1 = page['vars']['nbr_products_pg1']
end


products.take(1).each_with_index do |product, i|



  name= product['name']

  category = data['categories'][0]['name']
  availability = product['stock'] == true ? '1' : ''
  pack = product['totalQuantity'].to_i == 0 ? '1' : product['totalQuantity'].to_i


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
      RETAILER_ID: '100',
      RETAILER_NAME: 'deliveryextra',
      GEOGRAPHY_NAME: 'BR',
      # - - - - - - - - - - -
      SCRAPE_INPUT_TYPE: page['vars']['input_type'],
      SCRAPE_INPUT_SEARCH_TERM: page['vars']['search_term'],
      SCRAPE_INPUT_CATEGORY: page['vars']['input_type'] == 'taxonomy' ? category : '-',
      SCRAPE_URL_NBR_PRODUCTS: scrape_url_nbr_products,
      # - - - - - - - - - - -
      SCRAPE_URL_NBR_PROD_PG1: nbr_products_pg1,
      # - - - - - - - - - - -
      PRODUCT_BRAND: product['displayBrand'],
      PRODUCT_RANK: i + 1,
      PRODUCT_PAGE: current_page + 1,
      PRODUCT_ID: product['id'],
      PRODUCT_NAME: product['name'],
      PRODUCT_DESCRIPTION: "",
      PRODUCT_MAIN_IMAGE_URL: "https://www.deliveryextra.com.br"+product['thumbPath'].gsub(/50x50/,'200x200'),
      PRODUCT_ITEM_SIZE: item_size,
      PRODUCT_ITEM_SIZE_UOM: uom,
      PRODUCT_ITEM_QTY_IN_PACK: pack,
      SALES_PRICE: product['currentPrice'],
      IS_AVAILABLE: availability,
      PROMOTION_TEXT: "",
  }
  pages << {
      page_type: 'product_reviews',
      method: 'GET',
      url: "https://api.gpa.digital/ex/products/#{product['id']}/review?&searchkeyword=#{page['vars']['search_term']}&searchpage=#{page['vars']['page']}",
      vars: {
          'product_details' => product_details
      }


  }


end

