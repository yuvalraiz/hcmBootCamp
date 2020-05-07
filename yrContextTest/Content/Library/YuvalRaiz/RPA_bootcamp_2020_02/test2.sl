namespace: YuvalRaiz.RPA_bootcamp_2020_02
flow:
  name: test2
  workflow:
    - sleep:
        do:
          io.cloudslang.base.utils.sleep: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      sleep:
        x: 105.01705932617188
        'y': 114.02841186523438
        navigate:
          e5afee2f-de78-8620-de55-d05bb1577c0f:
            targetId: 06d0aec6-00d9-f195-9391-3b3ce3e9f210
            port: SUCCESS
    results:
      SUCCESS:
        06d0aec6-00d9-f195-9391-3b3ce3e9f210:
          x: 395.0170593261719
          'y': 57.752845764160156
