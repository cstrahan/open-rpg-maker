Open RPG Maker
==============


About
-----

**Open RPG Maker** is an IronRuby port of [RPG Maker XP][1]. The goal is to create a cross platform host for running RMXP games. By abstracting the executing environment from the implementation, support is planned for WPF, Silverlight and WinForms.


Status
------

**Open RPG Maker** is currently a work in progress.


Roadmap
-------

There's a *lot* to do right now:

 1. Recreate the resource files (*.rxdata) in an unencrypted format.
 2. Finish the *RPG* module, and create the *load_data(filename)* and *save_data(obj, filename)* bult-ins.
 3. Redefine *p* and *print* for use in message box output.
 4. Document the *RPG* module.
 5. Create the bootstrapper for WPF, Silverlight, and WinForms.
 6. Create unit tests.
 7. Figure out what this is (from troop.rb): RPG::BattleEventPage.new


  [1]: http://tkool.jp/products/rpgxp/eng