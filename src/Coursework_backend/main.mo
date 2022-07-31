import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Person "Persons";
import Persons "Persons";
import Trie "mo:base/Trie";

actor {
  
     public type Person = Persons.Persons;
  stable var persons : Trie.Trie<Nat,Person> = Trie.empty();
  stable var next : Nat = 0;


  //  public func add (lastName : Text , firstName : Text, sex : Bool , dateOfBirth : Text, phone : Nat, address : Text): async Person{
  //    let person : Persons.Persons = {
  //     lastName = lastName;  
  //     firstName = firstName;
  //     sex = sex;
  //     dateOfBirth =  dateOfBirth;
  //     phone = phone;  
  //     address = address;
  //         };

  //         return person;
  //   };
    private func key(x : Nat): Trie.Key<Nat>{
      return{
        key = x;
        hash = Hash.hash(x);
      };
    };

    public func adds(p : Person): async Bool{
      next += 1;
      let  id = next;

      let (newPersons, existing) = Trie.put(
        persons,
        key(id),
        Nat.equal,
        p,
      );
      switch (existing){
        case (null) {persons := newPersons;
        };
        case (?v) {return false;
        };
      };
      return true;
    };

    // read func
    public func read_account(id : Nat): async ?Person{
      let result = Trie.find(
        persons,key(id), Nat.equal
      );
      return result;
    };

    // write update func
    public func update_account(id: Nat, p : Person): async Bool{
      let result = Trie.find(
        persons,key(id),Nat.equal
      );
      switch(result) {
          //Not update
          case (null) {
            return false;
          };
          case (?v) {
            persons := Trie.replace(
              persons,key(id),Nat.equal,?p
            ).0;
          };  
        };
        return true;
    };
    
    // write delete 
    public func delete_account(id : Nat) : async Bool{
      let result = Trie.find(
        persons,key(id),Nat.equal
      );
      switch(result){
        case(null){return false};
        case(?v){
          persons := Trie.replace(
            persons,key(id), Nat.equal,null
          ).0;
        };
      };
      return true;
    };
     
};
