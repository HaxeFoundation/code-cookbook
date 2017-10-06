[tags]: / "abstract-type"

# Array access of a database manager

When using SPOD database objects, or the [_record-macros_ library](https://github.com/HaxeFoundation/record-macros), instances of database models can be accessed using the manager's `get` function:

```haxe
var user42 = User.manager.get(42);
```

By abstracting over the user's manager class, we can add array access functionality to easily grab a user by their primary key (id):

```haxe
var user42 = userManager[42];
```

We can also use a shortcut for inserting a new user at a specific id if we so desire:

```haxe
userManager[21] = new User("Douglas");
```

Or even abuse the array access by providing `null` to auto-assign a new id:

```haxe
userManager[null] = new User("Zaphod");
```


## Implementation

```haxe
import sys.db.Object;
import sys.db.Types;
import sys.db.Manager;

class User extends Object {
    public var id:SId;
    public var name:SString<255>;

    public function new(name:String) {
        super();
        this.name = name;
    }

    override public function toString()
        return this.name + ' (${this.id})';
}

@:forward
abstract UserManager(Manager<User>) from Manager<User> to Manager<User> {
    public function new()
        this = User.manager;

    @:arrayAccess
    inline function getUserById(id:Int)
        return this.get(id);

    @:arrayAccess
    inline function setUserById(id:Null<Int>, user:User):User {
        if(id != null) user.id = id;
        user.insert();
        return user;
    }
}
```

## Usage

Description of how to use/test the code.

```haxe
import sys.db.Sqlite;
import sys.db.TableCreate;
import sys.db.Manager;

class Main {
    static function main() {
        Manager.cnx = Sqlite.open('array-access.db');

        var userManager:UserManager = new UserManager();
        if(!TableCreate.exists(userManager)) {
            Sys.println('Creating user table...');
            TableCreate.create(userManager);
        }

        var user:User = new User("Bob");
        user.insert();
        Sys.println('Created new user: ${user}');

        var uid:Int = user.id;
        userManager[42] = new User("Douglas");
        Sys.println('Created another new user: ${userManager[42]}');

        var thirdUser = new User("Abed");
        userManager[null] = thirdUser;
        Sys.println('Created yet another new user: ${thirdUser}');

        user.delete();
        userManager[42].delete();
        thirdUser.delete();
    }
}
```

Outputs:

```
Creating user table...
Created new user: Bob (1)
Created another new user: Douglas (42)
Created yet another new user: Abed (43)
```

> More on this topic: 
> 
> * [Array Access in Haxe Manual](https://haxe.org/manual/types-abstract-array-access.html)
> * [record-macros library](https://github.com/HaxeFoundation/record-macros)
> 
> Author: [Kenton Hamaluik](https://github.com/FuzzyWuzzie)