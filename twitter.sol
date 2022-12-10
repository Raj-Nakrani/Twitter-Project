// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;



contract twitter{
   

   struct Tweet{
       uint id;
       address author;
       uint createdAt;
       string content;
   }

   struct Message{
       uint id;
       address from;
       address to;
       string content;
       uint createdAt;
       
       

   }

   mapping(uint=>Tweet) public tweets;
   mapping(address=>uint[]) public tweetsof;
   mapping(address=>address[]) followers;
   mapping(address=>Message[]) conversation;
   mapping(address=>mapping(address=>bool)) public operators;
     
     uint nextId;
     uint nextMessageId;

    function tweet(address _from,string memory _content) internal {
        require(msg.sender == _from || operators[_from][msg.sender]==true,"You Are Not Authorized");
        tweets[nextId]=Tweet(nextId,_from,block.timestamp,_content);
        tweetsof[_from].push(nextId);
        nextId++;

    }

    function message(string memory _content,address _from,address _to) internal{
        require(msg.sender==_from || operators[_from][msg.sender]==true,"You Are Not Authorized");
        conversation[_from].push(Message(nextMessageId,_from,_to,_content,block.timestamp));
        nextMessageId++;
    }
    
    function tweet(string calldata content) public{
        tweet(msg.sender,content);
    }
    function tweetFrom(address _from,string memory _content) public{
        tweet(_from,_content);
       
    }

    function message(string memory content,address to) public{
        message(content,msg.sender,to);
    }
    function messageFrom(string memory content,address from ,address to) public{
        message(content,from,to);
    }
    function allow(address from) public{
        operators[msg.sender][from]=true;
    }
     function disallow(address from) public{
        operators[msg.sender][from]=false;
    }


 function getlatestTweet(uint count) public view returns(Tweet[] memory){

     require(count>0 && count<=nextId);
     Tweet[]  memory memTweet=new Tweet[](count);
      uint j;
     for(uint i=nextId-count;i<nextId;i++){
          Tweet storage _tweet=tweets[i];
          memTweet[j]=Tweet(_tweet.id,_tweet.author,_tweet.createdAt,_tweet.content);
          j++;
   }
        return memTweet;
 }

 function getTweetsof(address user,uint count) public view returns(Tweet[] memory){
     uint[] storage tweetsId=tweetsof[user];
     Tweet[] memory newtweets= new Tweet[](count);
     uint j;
     for(uint i=tweetsId.length-count;i<tweetsId.length;i++){
         Tweet storage _tweet=tweets[tweetsId[i]];
         newtweets[j]=Tweet(_tweet.id,_tweet.author,_tweet.createdAt,_tweet.content);
         j++;
     }

   return newtweets;

 }



}