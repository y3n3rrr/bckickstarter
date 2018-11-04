// solium-disable linebreak-style
pragma solidity ^0.4.17;


contract CampaignFactory{
    
    address[] public deployedCampaigns;
    
    function createCampaign(uint minCont) public{
        address newCampaign = new Campaign(minCont, msg.sender);
        deployedCampaigns.push(newCampaign);
    }
    function getDeployedCampaigns() public view returns(address[]){
        return deployedCampaigns;
    }
}


contract Campaign{
    
    struct Request{
        string description;
        uint value;
        address receipt;
        bool isComplete;
        uint approvalCount;
        mapping(address=> bool) approvals;
    }
    
    modifier authManagerCall(){
        require(msg.sender == manager);
        _;
    }
    
    Request[] public requests;
    address public manager;
    uint public minumumContribution;
    mapping(address=> bool) public approves;
    uint public approvesCount;
    
    function Campaign(uint _minumumContribution, address sender) public payable {
        manager=sender;
        minumumContribution = _minumumContribution;
    }
    
    function contribute(uint amount) public payable {
        require(amount >= minumumContribution);
        
        if(!approves[msg.sender])
            approvesCount++;
        approves[msg.sender] = true;
    }
    
    function createRequest(string description, uint value, address receipt) public authManagerCall payable{
        Request memory request_ = Request({
            description:description,
            value:value,
            receipt:receipt,
            isComplete:false,
            approvalCount:0
        });
        
        requests.push(request_);
    }
    
    function approveRequest(uint index) public {
        require(approves[msg.sender]);
        Request storage _reqTobeApproved = requests[index];
        
        require(!_reqTobeApproved.approvals[msg.sender]);
        _reqTobeApproved.approvalCount++;
        _reqTobeApproved.approvals[msg.sender]=true;
    }
    
    function finalizeRequest(uint index) public payable authManagerCall {
        Request storage _req = requests[index];
        require(!_req.isComplete);
        require(_req.approvalCount >= (approvesCount / 2));

        _req.receipt.transfer(_req.value);
        _req.isComplete = true;
    }
    
}

