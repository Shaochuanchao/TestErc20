pragma solidity >0.7.0 <0.9.0;

library LibScc{
    
    
    function isContract(address _to) public view returns (bool){
       uint size;
        assembly{
             size := extcodesize(_to)
        }
         return size >0;
    }
    
    
}