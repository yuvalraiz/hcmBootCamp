namespace: demo
flow:
  name: CreateVM
  workflow:
    - uuid:
        do:
          io.cloudslang.demo.uuid: []
        publish:
          - uuid: '${"yr-"+uuid}'
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      uuid:
        x: 100
        y: 150
        navigate:
          23a56eb1-cac4-f0a3-ec9f-4119f1278517:
            targetId: 93e1f77c-2a0b-86d6-eb7a-e04b80d1f8ab
            port: SUCCESS
    results:
      SUCCESS:
        93e1f77c-2a0b-86d6-eb7a-e04b80d1f8ab:
          x: 400
          y: 150
