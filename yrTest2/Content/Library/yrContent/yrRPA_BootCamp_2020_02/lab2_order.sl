namespace: yrContent.yrRPA_BootCamp_2020_02
flow:
  name: lab2_order
  inputs:
    - username: mfadmin
    - password: MFdemo@12345
    - product_id: '10'
    - color_code: C3C3C3
  workflow:
    - authenticate:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${\"http://%s:%s/accountservice/AccountLoginRequest\" % (get_sp('AOSServer'),get_sp('AOSPort'))}"
            - body: "${'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><AccountLoginRequest xmlns=\"com.advantage.online.store.accountservice\"><email></email><loginUser>%s</loginUser><loginPassword>%s</loginPassword></AccountLoginRequest></soap:Body></soap:Envelope>'%(username, password)}"
            - content_type: text/xml
        publish:
          - soap: '${return_result}'
        navigate:
          - SUCCESS: get_userid
          - FAILURE: on_failure
    - http_client_post_1:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${\"http://%s:%s/order/api/v1/carts/%s/product/%s/color/%s\" % (get_sp('AOSServer'),get_sp('AOSPort'),user_id, product_id, color_code)}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_userid:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${soap}'
            - xpath_query: '//ns2:userId/text()'
        publish:
          - user_id: '${selected_value}'
        navigate:
          - SUCCESS: get_userid_2
          - FAILURE: on_failure
    - get_userid_2:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${soap}'
            - xpath_query: '//ns2:t_authorization/text()'
        publish:
          - token: '${selected_value}'
        navigate:
          - SUCCESS: http_client_post_1
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_post_1:
        x: 488
        'y': 90
        navigate:
          2b196b62-f3d3-182e-cc9a-7316ff2edc98:
            targetId: 1d03930c-c576-240c-29de-35d16064aa0f
            port: SUCCESS
      authenticate:
        x: 25
        'y': 74
      get_userid_2:
        x: 341.0170593261719
        'y': 88.02841186523438
      get_userid:
        x: 184
        'y': 77
    results:
      SUCCESS:
        1d03930c-c576-240c-29de-35d16064aa0f:
          x: 475
          'y': 282
