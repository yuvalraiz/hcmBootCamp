namespace: demo
flow:
  name: CreateVM
  inputs:
    - host: 10.0.46.10
    - username: "Capa1\\1286-capa1user"
    - password:
        value: Automation123
        sensitive: true
    - datacenter: Capa1 Datacenter
    - image: Ubuntu
    - folder: Students/raiz
    - prefix_list: '1-,2-,3-'
  workflow:
    - uuid:
        do:
          io.cloudslang.demo.uuid: []
        publish:
          - uuid: '${"yr-"+uuid}'
        navigate:
          - SUCCESS: substring
    - substring:
        do:
          io.cloudslang.base.strings.substring:
            - origin_string: '${uuid}'
            - end_index: '13'
        publish:
          - id: '${new_string}'
        navigate:
          - SUCCESS: clone_vm
          - FAILURE: on_failure
    - clone_vm:
        do:
          io.cloudslang.vmware.vcenter.vm.clone_vm: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      uuid:
        x: 100
        y: 150
      substring:
        x: 400
        y: 150
      clone_vm:
        x: 700
        y: 150
        navigate:
          cf09653d-e8ab-dac1-09e0-e11c184400aa:
            targetId: a8006722-60d1-0ed9-6862-4d9fd274d2b4
            port: SUCCESS
    results:
      SUCCESS:
        a8006722-60d1-0ed9-6862-4d9fd274d2b4:
          x: 1000
          y: 150
