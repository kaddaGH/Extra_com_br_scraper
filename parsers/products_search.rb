data = JSON.parse(content)


if data.key?('content')
  data = data['content']
  scrape_url_nbr_products = data['totalElements'].to_i
  current_page = data['number'].to_i
  page_size = data['size'].to_i
  number_of_pages = data['totalPages'].to_i
  products = data['products']

else
  scrape_url_nbr_products = data['result_meta']['total'].to_i
  current_page = data['pages']['current']['name'].to_i-1 rescue 0
  page_size = data['result_meta']['this_page'].to_i
  number_of_pages = data['pages']['total'].to_i
  products = data['results']
end


# if it's first page , generate pagination
if current_page == 0 and number_of_pages > 1
  nbr_products_pg1 = products.length
  step_page = 1
  while step_page < number_of_pages
    url = page['url'].gsub(/p=0/, "p=#{step_page}")
    url = url.gsub(/\&srt=0/, "\&srt=#{step_page*page_size}")

    pages << {
        page_type: 'products_search',
        method: 'GET',
        url: url,
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

unless  products.nil?

  products.each_with_index do |product, i|

    if product.key?('id')

      product_id = product['id']
    else

      product_id = product['url'][/\d+?\Z/]

    end

    pages << {
        page_type: 'product_details',
        method: 'GET',
        url: "https://api.gpa.digital/ex/v3/products/ecom/#{product_id}?storeId=241&isClienteMais=false&searchkeyword=#{page['vars']['search_term']}&searchpage=#{page['vars']['page']}",
        vars: {
            'input_type' => page['vars']['input_type'],
            'search_term' => page['vars']['search_term'],
            'page' => page['vars']['page'],
            'nbr_products_pg1' => nbr_products_pg1,
            'scrape_url_nbr_products'=>scrape_url_nbr_products,
            'rank' => i+1
        }


    }
  end

end



