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

    mapping(string=>Content) public contentIdToContent;
    string[] public content;
    uint256 numContent;

    struct Caption {
        string captionId;
        uint256 votes;
    }

    struct Content {
        uint256 totalVotes;
        Caption[] captions;
    }
    
    //
    // WRITES TO BLOCKCHAIN
    //

    // This says that it can be view, but it changes totalVotes?
    function voteContent(string memory _con , uint256 _amount) external {
        require(rewards[msg.sender] >= _amount);
        // rewards decrease
        rewards[msg.sender].sub(_amount);
        // do something like rewards.minus(1);
        // increase votes for contentID
        contentIdToContent[_con].totalVotes.add(_amount);
        // Issues
        // No _con in contentId, do you call makeNewContent?
    }

    // This says that it can be view, but it changes caption votes?
    function voteCaption(string memory _con, uint256 _index, uint256 _amount) external {
        require(rewards[msg.sender] >= _amount);
        // rewards decrease
        rewards[msg.sender].sub(_amount);
        // increase votes for contentID
        // @dev requires you to know the index of the caption
        contentIdToContent[_con].captions[_index].votes.add(_amount);
        // Issues
        // No _con in contentId, do you call makeNewContent? Then assign a caption?
        // No _cap, do you call makeNewCaption?
    }

    // _str is the content hash
    // should there be a limiting factor for making/adding new content
    function makeNewContent(string memory _con) public {    
        content.push(_con); // what happens if two content hashes are the same?
        contentIdToContent[_con].totalVotes = 0;
        // do we do anything to captions?
        emit NewContent(content.length);
    }

    // Utility function
    // function quickSort(int left, int right) external returns (Content[]){
    //     Content[] memory arr = content;
    //     int i = left;
    //     int j = right;
    //     if(i==j) return arr;
    //     uint pivot = arr[uint(left + (right - left) / 2)].totalVotes;
    //     while (i <= j) {
    //         while (arr[uint(i)].totalVotes < pivot) i++;
    //         while (pivot < arr[uint(j)].totalVotes) j--;
    //         if (i <= j) {
    //             (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
    //             i++;
    //             j--;
    //         }
    //     }
    //     if (left < j) 
    //         quickSort(arr, left, j);
    //     if (i < right)
    //         quickSort(arr, i, right);
    // }

    // External public view
    // function getTopN(uint256 memory _n) external view {
    //     require(_n < numContent);
    //     Content[] memory sortedContent = new Content[_n];
    //     // Sort content
        

    //     return sortedContent[:_n];
    // }

    // 
    // READS THE BLOCKCHAIN
    //

    function getContent(uint256 _index) external view returns(string memory){
        return content[_index];
    }

    function getContentLength() external view returns(uint256){
        return content.length;
    }

    //
    // EVENTS
    //
    event NewContent(uint256 id);
}
    
