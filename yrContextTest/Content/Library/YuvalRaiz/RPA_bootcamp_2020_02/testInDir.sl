namespace: YuvalRaiz.RPA_bootcamp_2020_02
flow:
  name: testInDir
  workflow:
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: yuval
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      is_true:
        x: 196
        'y': 129
        navigate:
          e53d12c2-f912-aa8e-22ae-799fd631ce05:
            targetId: 73b05856-b163-6eac-12d4-48bccad3133d
            port: 'FALSE'
          6ff4c97a-47a8-16b4-5747-f07344cbb6f8:
            targetId: 73b05856-b163-6eac-12d4-48bccad3133d
            port: 'TRUE'
    results:
      SUCCESS:
        73b05856-b163-6eac-12d4-48bccad3133d:
          x: 308
          'y': 113
