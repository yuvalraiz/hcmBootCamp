namespace: yrContent.yrRPA_BootCamp_2020_02
flow:
  name: FirstLab_GoOverCategory
  inputs:
    - json
    - category_id
    - filename
  workflow:
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$[?(@.categoryId == \"'+category_id+'\")]'}"
        publish:
          - category_json: '${return_result}'
        navigate:
          - SUCCESS: json_path_query_1
          - FAILURE: on_failure
    - json_path_query_1:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${category_json}'
            - json_path: '$.*.categoryName'
        publish:
          - category_name: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: json_path_query_2
          - FAILURE: on_failure
    - json_path_query_2:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${category_json}'
            - json_path: '$.*.products.*.productId'
        publish:
          - products_ids: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: FirstLab_GoOverProductsInCategory
          - FAILURE: on_failure
    - FirstLab_GoOverProductsInCategory:
        loop:
          for: product_id in products_ids
          do:
            yrContent.yrRPA_BootCamp_2020_02.FirstLab_GoOverProductsInCategory:
              - json: '${category_json}'
              - product_id: '${product_id}'
              - filename: '${filename}'
              - category_id: '${category_id}'
              - category_name: '${category_name}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      FirstLab_GoOverProductsInCategory:
        x: 683
        'y': 124
        navigate:
          dfb30636-9926-17a6-0b8e-773ea4fb0ccb:
            targetId: b19da2c4-6622-1203-5863-110ce41e9aa6
            port: SUCCESS
      json_path_query:
        x: 91
        'y': 115
      json_path_query_1:
        x: 272
        'y': 117
      json_path_query_2:
        x: 491
        'y': 120
    results:
      SUCCESS:
        b19da2c4-6622-1203-5863-110ce41e9aa6:
          x: 909
          'y': 127
