/*

      Select for retriving flexfield information for specific modules or tables
      
      Credit to:
      ******* http://sanjaimisra.blogspot.com/2010/04/flexfield-list.html ******
      
*/
SELECT 
       fa.application_short_name       "Application"
     , fdft.title                      "Flex Field Title"
     , fdf.descriptive_flexfield_name  "Flex Field Name"
     , fdf.application_table_name      "Table"
     , fdf.freeze_flex_definition_flag "Freeze"
     , fdf.protected_flag              "Protected"
     , fdf.context_column_name         "Context Column"
     , fdft.form_context_prompt        "Form Context Prompt"
     , fdf.default_context_field_name  "Default Context Field"
     , fdf.context_required_flag       "Required"
     , fdf.context_user_override_flag  "Display Flag"
     , ffvs.flex_value_set_name        "Conext Value Set"

  FROM applsys.fnd_descriptive_flexs        fdf
     , applsys.fnd_descriptive_flexs_tl     fdft
     , applsys.fnd_application              fa    
     , applsys.fnd_flex_value_sets          ffvs
 WHERE fdf.application_id                  = fdft.application_id
   AND fdf.descriptive_flexfield_name      = fdft.descriptive_flexfield_name
   AND fa.application_id                   = fdf.application_id
   AND fdf.context_override_value_set_id = ffvs.flex_value_set_id (+)
   AND fdft.title not like '$SRS$%'
   AND fdft.language = 'US' -- remove if another language is being used
   /* Use if to get information about specific module Flexfields */
   --AND fa.application_short_name in ('AR', 'SQLAP', 'PO', 'SQLGL', 'PA')
   /* Use if need to find lookup values for a specific table */
   --AND fdf.application_table_name = 'FND_LOOKUP_VALUES'
 ORDER BY 1,2
