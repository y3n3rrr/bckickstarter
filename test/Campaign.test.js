const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3')

const web3 = new Web3(ganache.provider());
const compiledFactory = require('../etherium/build/CampaignFactory.json');
const compiledCampaign = require('../etherium/build/Campaign.json');

let accounts;
let factory;
let campaignAddress;
let campaign;

beforeEach(async ()=>{
    //get first account
    [accounts] = await web3.eth.getAccounts();

    //create contract of catorycampaign
    factory = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
    .deploy({data:compiledFactory.bytecode})
    .send({from:accounts, gas:'10000000'});

    //create campaign using factory contract methods
    await factory.methods.createCampaing('1000').send({from:accounts, gas:'100000'});

    //get address of created campaign contract address and create web3 referance of it
    [campaignAddress] = await factory.methods.getDeployedContracts.call();
    campaign = await new web3.eth.Contract(JSON.parse(compiledCampaign.interface), campaignAddress);
});