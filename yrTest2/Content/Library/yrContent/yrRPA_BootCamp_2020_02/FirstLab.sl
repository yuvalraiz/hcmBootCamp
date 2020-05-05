########################################################################################################################
#!!
#! @input filename: txt|xlslx
#!!#
########################################################################################################################
namespace: yrContent.yrRPA_BootCamp_2020_02
flow:
  name: FirstLab
  inputs:
    - filename: firstlab.xlsx
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'http://'+get_sp('AOSServer')+':'+get_sp('AOSPort')+'/catalog/api/v1/categories/all_data'}"
        publish:
          - all_catalog_json: '${return_result}'
        navigate:
          - SUCCESS: delete
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${all_catalog_json}'
            - json_path: '$.*.categoryId'
        publish:
          - categoies_ids: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: FirstLab_GoOverCategory
          - FAILURE: on_failure
    - write_to_file:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: '${file_path}'
            - text: "${'+'+'+'.join([''.center(13,'-'),''.center(15,'-'),''.center(12,'-'),''.center(51,'-'),''.center(15,'-'),''.center(60,'-')])+'+\\n'+\\\n'|'+'|'.join(['Category ID'.center(13),'Category Name'.center(15),'Product ID'.center(12),'Product Name'.center(51),'Product Price'.center(15),'Color Codes'.center(60)])+'|\\n'+\\\n'+'+'+'.join([''.center(13,'-'),''.center(15,'-'),''.center(12,'-'),''.center(51,'-'),''.center(15,'-'),''.center(60,'-')])+'+\\n'}"
        publish: []
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - FirstLab_GoOverCategory:
        loop:
          for: category_id in categoies_ids
          do:
            yrContent.yrRPA_BootCamp_2020_02.FirstLab_GoOverCategory:
              - json: '${all_catalog_json}'
              - category_id: '${category_id}'
              - filename: '${file_path}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - New_Excel_Document:
        do_external:
          9d21ca68-7d03-4fb3-9478-03956532bf6f:
            - excelFileName: '${file_path}'
            - worksheetNames: Products
            - delimiter: ','
        publish:
          - returnResult
        navigate:
          - failure: on_failure
          - success: json_path_query
    - is_excel:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(filename.endswith("xls") or filename.endswith("xlsx"))}'
        navigate:
          - 'TRUE': New_Excel_Document
          - 'FALSE': write_to_file
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: "${'c:\\\\temp\\\\'+filename}"
        publish:
          - file_path: '${source}'
        navigate:
          - SUCCESS: is_excel
          - FAILURE: is_excel
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_get:
        x: 24
        'y': 72
      json_path_query:
        x: 529
        'y': 222
      write_to_file:
        x: 366
        'y': 338
      FirstLab_GoOverCategory:
        x: 704
        'y': 225
        navigate:
          5f3364c3-35cd-a6b9-bb8d-6218bfcf63d6:
            targetId: de57943c-e410-db1e-444c-53fdc26a16c5
            port: SUCCESS
      New_Excel_Document:
        x: 366
        'y': 107
      is_excel:
        x: 227
        'y': 222
      delete:
        x: 27
        'y': 225
    results:
      SUCCESS:
        de57943c-e410-db1e-444c-53fdc26a16c5:
          x: 902
          'y': 25
