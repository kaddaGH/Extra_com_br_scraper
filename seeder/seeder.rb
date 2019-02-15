require 'cgi'

search_terms = ['Energético']
search_terms.each do |search_term|
  pages << {
      page_type: 'products_search',
      method: 'GET',
      url:"https://deliveryextra.resultspage.com/search?p=Q&ts=json-full&lot=json&w=#{CGI.escape(search_term)}&cnt=12&srt=0&ref=www.deliveryextra.com.br&ua=Mozilla%2F5.0%20(Macintosh%3B%20Intel%20Mac%20OS%20X%2010_10_0)%20AppleWebKit%2F537.36%20(KHTML%2C%20like%20Gecko)%20Chrome%2F71.0.3578.98%20Safari%2F537.36&ep.selected_store=241",
      vars: {
          'input_type' => 'search',
          'search_term' => search_term,
          'page' => 1
      }


  }

end