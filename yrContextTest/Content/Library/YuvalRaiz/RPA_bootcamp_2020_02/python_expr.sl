namespace: YuvalRaiz.RPA_bootcamp_2020_02
flow:
  name: python_expr
  workflow:
    - sleep_1_2:
        loop:
          for: i in range(5)
          do:
            io.cloudslang.base.utils.sleep:
              - seconds: '${str(10 if i % 2 == 0 else 0)}'
              - name: name
          break:
            - FAILURE
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: |-
                ${'''
                {{
                    "central" : {{
                        "hostname": "{hostname}",
                        "port" : "{central_port}"
                    }},
                    "designer" : {{
                        "hostname": "{hostname}",
                        "port" : "{designer_port}"
                    }},
                    "ssx" : {{
                        "hostname": "{hostname}",
                        "port" : "{ssx_port}"
                    }}
                }}
                '''.format(hostname="rpa.mf-te.com", central_port=8443, designer_port=8445, ssx_port=8446)}
            - json_path: $.central.hostname
        publish:
          - return_result
        navigate:
          - SUCCESS: json_path_query_1
          - FAILURE: on_failure
    - get_token:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${get_sp('ssx_url')}"
            - auth_type: basic
            - username: admin
            - password:
                value: 
                sensitive: true
            - method: HEAD
        publish:
          - token: "${response_headers.split('X-CSRF-TOKEN:')[1].split('\\n')[0].strip()}"
          - length: '${str(len(token))}'
        navigate:
          - SUCCESS: get_categories
          - FAILURE: on_failure
    - get_categories:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'%s/rest/v0/categories' % get_sp('ssx_url')}"
            - auth_type: anonymous
            - username: null
            - password:
                value: 
                sensitive: true
            - headers: "${'X-CSRF-TOKEN:%s' % token}"
            - method: GET
        publish:
          - categories_json: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - sleep:
        loop:
          for: 'name,i in eval(names)'
          do:
            io.cloudslang.base.utils.sleep:
              - seconds: '${str(i+len(name))}'
              - name: '${name}'
          break:
            - FAILURE
        navigate:
          - SUCCESS: get_token
          - FAILURE: on_failure
    - json_path_query_1:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '{"names":["Petr","Ron","Mike","Lori"]}'
            - json_path: $.names
        publish:
          - names: '${return_result}'
        navigate:
          - SUCCESS: sleep_1
          - FAILURE: on_failure
    - sleep_1:
        loop:
          for: pair in enumerate(eval(names))
          do:
            io.cloudslang.base.utils.sleep:
              - seconds: '${str(pair[0])}'
              - name: '${pair[1]}'
          break:
            - FAILURE
        navigate:
          - SUCCESS: sleep_1_1
          - FAILURE: on_failure
    - json_path_query_1_1:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '{"names":{"Petr":1,"Ron":2,"Mike":3,"Lori":4}}'
            - json_path: $.names
        publish:
          - names: '${return_result}'
        navigate:
          - SUCCESS: sleep
          - FAILURE: on_failure
    - sleep_1_1:
        loop:
          for: name in eval(names)
          do:
            io.cloudslang.base.utils.sleep:
              - seconds: '${str(eval(names).index(name))}'
              - name: '${name}'
          break:
            - FAILURE
        navigate:
          - SUCCESS: json_path_query_1_1
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_categories:
        x: 450
        'y': 544
        navigate:
          e5afee2f-de78-8620-de55-d05bb1577c0f:
            targetId: 06d0aec6-00d9-f195-9391-3b3ce3e9f210
            port: SUCCESS
      json_path_query:
        x: 133
        'y': 236
      json_path_query_1_1:
        x: 623
        'y': 374
      sleep_1:
        x: 480
        'y': 224
      get_token:
        x: 266
        'y': 495
      json_path_query_1:
        x: 314
        'y': 227
      sleep:
        x: 80
        'y': 439
      sleep_1_1:
        x: 620
        'y': 224
      sleep_1_2:
        x: 44
        'y': 84
    results:
      SUCCESS:
        06d0aec6-00d9-f195-9391-3b3ce3e9f210:
          x: 631
          'y': 630
