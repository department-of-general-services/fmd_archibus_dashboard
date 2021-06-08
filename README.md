# FMD Dashboard: V3
Contains XML files used for dashboarding in Archibus.

To create the dashboard from this directory, run:
    ```
    $ python wrap_for_prod.py
    ```

This will remove the backdating from SQL that is needed to test the dashboard and create a zipped archive in your /Documents folder. This zipped archive must be ported to the production environment to build the dashboard there. 
