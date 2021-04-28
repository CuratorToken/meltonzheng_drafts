// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import "./CuratorToken.sol";
import {SafeMath} from "../openzeppelin-contracts-3.4.0/contracts/math/SafeMath.sol";
import {IERC20} from "../openzeppelin-contracts-3.4.0/contracts/token/ERC20/IERC20.sol";

contract Voting is CuratorToken {

    using SafeMath for uint256;

    // Variables
    // No hashing necessary, already hashed.
    // struct Multihash {
    //  bytes32 hash
    // uint8 hash_function
    //  uint8 size
    //}

    mapping(string=>ContentObj) public contentToContentObj;
    string[] content;
    uint256 numContent;

    struct ContentObj {
        string[] captions;
        mapping(string => uint256) captionToVote;
        uint256 totalVotes;
    }
    
    function voteContent(string memory _con) external {
        require(rewards[msg.sender] > 0);
        // rewards decrease
        // rewards[msg.sender] = rewards[msg.sender].subtract(1);
        // do something like rewards.minus(1);
        // increase votes for contentID
        contentToContentObj[_con].totalVotes.add(1);
    }

    function voteCaption(string memory _con, string memory _cap) external {
        require(rewards[msg.sender] > 0);
        // rewards decrease
        rewards[msg.sender].sub(1);
        //increase votes for contentID
        contentToContentObj[_con].captionToVote[_cap].add(1);
    }

    // _str is the content hash
    function makeNewContent(string memory _con) internal {
        content.push(_con);
        numContent++;
        emit NewContent(_con, numContent);
    }


    // Events
    event NewContent(string contentHash, uint256 id);
}
    
