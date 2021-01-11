# Chart Notes

## Things that will break your chart

### You must specify the type for all fields 

If you have this code:

        <field table="bl"
            name="total_area_gp"
            dataType="number"/>

And you omit the third line, you will get this error: 

    "Cannot read property 'length' of undefined".

The same goes for text fields. If you leave out the dataType attribute, you'll get the same cryptic error.

### You can only specify groupBy if the datasource type is grouping

If you specify a field as having groupby capabilities:

        <field table="bl"
            name="site_id"
            groupBy="true"/>

Then you _must_ include the attribute 'grouping="true"' in the datasource specification. If you do not, then you will get this error:

    Loading DataSource definition with id=[chartDrillDown_jt_ds_disaggregated].


## Things that will NOT break your chart

### Importing a .js file and not using it

### Creating a datasource and not using it
