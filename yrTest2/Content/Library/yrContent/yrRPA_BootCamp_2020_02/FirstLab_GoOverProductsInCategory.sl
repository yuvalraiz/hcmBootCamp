namespace: yrContent.yrRPA_BootCamp_2020_02
flow:
  name: FirstLab_GoOverProductsInCategory
  inputs:
    - json
    - product_id
    - filename
    - category_id
    - category_name
  workflow:
    - get_product_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.*.products[?(@.productId == '+product_id+')].productName'}"
        publish:
          - product_name: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_product_price
          - FAILURE: on_failure
    - get_product_price:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.*.products[?(@.productId == '+product_id+')].price'}"
        publish:
          - product_price: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.*.products[?(@.productId == '+product_id+')].colors.*.code'}"
        publish:
          - color_codes: "${filter(lambda ch: ch not in '\"', return_result)[1:-1]}"
        navigate:
          - SUCCESS: is_excel
          - FAILURE: on_failure
    - add_text_to_file:
        do:
          io.cloudslang.base.filesystem.add_text_to_file:
            - file_path: '${filename}'
            - text: "${\"|\"+\"|\".join([category_id.rjust(13),category_name.ljust(15),product_id.rjust(12),product_name.ljust(51),product_price.rjust(15),color_codes.ljust(60)])+\"|\\n\"}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - is_excel:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(filename.endswith("xls") or filename.endswith("xlsx"))}'
        navigate:
          - 'TRUE': Add_Excel_Data
          - 'FALSE': add_text_to_file
    - Add_Excel_Data:
        do_external:
          4552e495-4595-4916-b58b-ce521bdb1e9a:
            - excelFileName: '${filename}'
            - worksheetName: Products
            - headerData: "${'Category ID,Category Name,Product ID,Product Name,Product Price,'+','.join(['Color Code'] * 8)}"
            - rowData: "${category_id+','+category_name+','+product_id+','+product_name+','+product_price+','+color_codes}"
            - columnDelimiter: ','
            - rowsDelimiter: '|'
            - overwriteData: 'false'
        navigate:
          - failure: on_failure
          - success: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_product_name:
        x: 50
        'y': 105
      add_text_to_file:
        x: 682
        'y': 252
        navigate:
          36b7bc72-3519-1db4-93ae-a19772ce4ec1:
            targetId: 32bb9cd3-0f46-babc-7306-44deda29312c
            port: SUCCESS
      json_path_query:
        x: 393
        'y': 118
      get_product_price:
        x: 213
        'y': 106
      is_excel:
        x: 527
        'y': 117
      Add_Excel_Data:
        x: 684
        'y': 40
        navigate:
          7921b582-976e-e1ed-eb78-20526f3d01c2:
            targetId: 32bb9cd3-0f46-babc-7306-44deda29312c
            port: success
    results:
      SUCCESS:
        32bb9cd3-0f46-babc-7306-44deda29312c:
          x: 853
          'y': 103
