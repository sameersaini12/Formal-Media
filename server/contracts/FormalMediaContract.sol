// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

contract FormalMediaContract {

    event AddTweet(address recipient, uint tweetId );
    event DeleteTweet(uint tweetId, bool isDeleted);
    event SetUpProfile(address userAddress, string name);

    // struct User {
    //     string name;
    // }

    struct Tweet {
        uint id;
        address username;
        string tweetText;
        bool isDeleted;
        string ddata;
        int like;
        int retweet;
    }

    Tweet[] private tweets;
    uint numRequests;
    
    mapping(uint256 => address) tweetToOwner;
    mapping(address => string) addressToUser;
    mapping(uint => Tweet) requests;

    function setUpProfile(address _userAddress , string memory _name) public {
        addressToUser[_userAddress] = _name;
        emit SetUpProfile(_userAddress, _name);
    }

    function getProfile(address _userAddress) external view returns (string memory) {
        return addressToUser[_userAddress];
    }


    function addTweet(string memory tweetText, bool isDeleted , string memory ddata) external {
        uint tweetId = tweets.length;
        uint index = tweets.length;
        tweets.push();
        Tweet storage t = tweets[index];
        t.id = tweetId;
        t.username = msg.sender;
        t.tweetText = tweetText;
        t.isDeleted = isDeleted;
        t.ddata = ddata;
        t.like = 0;
        t.retweet = 0;
        tweetToOwner[tweetId] = msg.sender;
        emit AddTweet(msg.sender, tweetId);
    }

    function getAllTweets() external view returns (Tweet[] memory) {
        Tweet[] memory temporary = new Tweet[](tweets.length);
        uint counter = 0;
        for(uint i=0; i<tweets.length; i++) {
            if(tweets[i].isDeleted == false) {
                temporary[counter] = tweets[i];
                counter++;
            }
        }

        Tweet[] memory result = new Tweet[](counter);
        for(uint i=0; i<counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    function getMyTweets() external view returns (Tweet[] memory) {
        Tweet[] memory temporary = new Tweet[](tweets.length);
        uint counter = 0;
        for(uint i=0; i<tweets.length; i++) {
            if(tweetToOwner[i] == msg.sender && tweets[i].isDeleted == false) {
                temporary[counter] = tweets[i];
                counter++;
            }
        }

        Tweet[] memory result = new Tweet[](counter);
        for(uint i=0; i<counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    function deleteTweet(uint tweetId, bool isDeleted) external {
        if(tweetToOwner[tweetId] == msg.sender) {
            tweets[tweetId].isDeleted = isDeleted;
            emit DeleteTweet(tweetId, isDeleted);
        }
    }

}