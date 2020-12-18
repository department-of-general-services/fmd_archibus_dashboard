# Chart Notes

## Things that will break your chart

### You must type all fields 

If you have this code:

        <field table="bl"
            name="total_area_gp"
            dataType="number"/>

And you omit the third line, you will get the error "Cannot read property 'length' of undefined".

The same goes for text fields. If you leave out the dataType attribute, you'll get the same cryptic error.



## Things that will NOT break your chart

### Importing a .js file and not using it

### Creating a datasource and not using it
