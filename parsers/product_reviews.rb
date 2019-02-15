data = JSON.parse(content)
reviews = data['content']
product_details = page['vars']['product_details']
product_details['PRODUCT_STAR_RATING'] = reviews["average"].to_f>0?reviews["average"]:""
product_details['PRODUCT_NBR_OF_REVIEWS'] = reviews ["total"].to_i
product_details['_collection'] = 'products'
product_details['EXTRACTED_ON']= Time.now.to_s
outputs << product_details



