// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract SimpleStorage {
    // bool flag = false;
    // uint256 num = 1974 ;
    // string mesg ="hello world" ;
    // address payeeAddress =  address(0);

    uint256 public favoriteNumber;
    People public person =
        People({favoriteNumber: 5, name: "Tom", married: false});
    People[] public people;

    mapping(string => uint256) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
        bool married;
    }

    function addPerson(
        string memory _name,
        uint256 _favoriteNumber,
        bool _married
    ) public {
        People memory _person = People({
            name: _name,
            favoriteNumber: _favoriteNumber,
            married: _married
        });
        people.push(_person);
        nameToFavoriteNumber[_name] = _person.favoriteNumber;
    }

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
}
