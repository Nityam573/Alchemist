const express = require('express');
const bodyParser = require('body-parser')

const app = express()

app.use(express.json())

const arr = ["0x8BAE1d8B813587AB74dE15019c03b5b874BBe8Ce",
             "0x8BAE1d8B813587AB74dE15019c03b5b874BBe8Ce",
             "0x8BAE1d8B813587AB74dE15019c03b5b874BBe8Ce",
             "0x8BAE1d8B813587AB74dE15019c03b5b874BBe8Ce",
             "0x8BAE1d8B813587AB74dE15019c03b5b874BBe8Ce",
             "0x8BAE1d8B813587AB74dE15019c03b5b874BBe8Ce"
              ];
// parse application/json
app.use(bodyParser.json())

// SMART CONTRACT CONFIG
let fs = require("fs");
const { Web3 } = require("web3");

// Assuming you are connecting from a local Ethereum node
const web3 = new Web3(new Web3.providers.HttpProvider('https://sepolia.infura.io/v3/e786bed0126448f7aa5006fd1ebb7a1a'));
const CONTRACTS_ADDRESS = "0x7543eB690a9E2Ea9fC0131DCbEe3305BBf3c76C1";
const macc = "0xa834a617C52146caA9D7Ebb16afEd9c0bE4fF3EC";
console.log("Helloo")
require('dotenv').config()

// let source = fs.readFileSync("./build/contracts/Tracking.json");
const tracking = require("./build/contracts/Tracking.json")

//SMART CONTRACT CONFIG ENDS


const supplyChainContract = new web3.eth.Contract(tracking.abi, CONTRACTS_ADDRESS);

app.get('/', (req, res) => { // new
  res.send('Homepage! Hello world.');
});

app.post('/addtlcRole',async(req,res)=>{
  try{
    const tlcRole = await supplyChainContract.methods.addTLCRole(req.body.account_id).send({from: macc});
    console.log(tlcRole);
    res.json({status:'TLC role added'});
  }
  catch(error){
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });}
})

app.post('/addconverterRole',async(req,res)=>{
  try{
    const converterRole = await supplyChainContract.methods.addConverterRole(req.body.account_id).send({from: macc});
    console.log(converterRole); 
    res.json({status:'Converter role added'});
  }
  catch(error){
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });}
})

app.post('/addlf1Role',async(req,res)=>{
  try{
    const lf1Role = await supplyChainContract.methods.addLF_1Role(req.body.account_id).send({from: macc});
    console.log(lf1Role); 
    res.json({status:'LF1 role added'});
  }
  catch(error){
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });}
})

app.post('/addlf2Role',async(req,res)=>{
  try{
    const lf2Role = await supplyChainContract.methods.addLF_2Role(req.body.account_id).send({from: macc});
    console.log(lf2Role); 
    res.json({status:'LF2 role added'});
  }
  catch(error){
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });}
})

app.post('/addrhRole',async(req,res)=>{
  try{
    const rhRole = await supplyChainContract.methods.addRHRole(req.body.account_id).send({from: macc});
    console.log(rhRole); 
    res.json({status:'RH role added'});
  }
  catch(error){
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });}
})

app.post('/addcastingRole',async(req,res)=>{
  try{
    const castingRole = await supplyChainContract.methods.addCastingRole(req.body.account_id).send({from: macc});
    console.log(castingRole); 
    res.json({status:'Casting role added'});
  }
  catch(error){
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });}
})


app.post('/shipbytlc', async (req, res) => { // new
  try {
    // console.log(req.body.account_id);
    const ladleid = req.body.ladleid;
    console.log(ladleid);
    console.log(arr[0]);    
    const manu = await supplyChainContract.methods.manufactureLadle(ladleid).send({from: arr[0],gasLimit: '6000000'});
    const transaction = await supplyChainContract.methods.shipToConverter(ladleid).send({from:arr[0],gasLimit: '6000000'});
    res.json({ status: 'Ladle sent successfully' });
    console.log(manu);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }

});

app.post('/shipbyconverter', async (req, res) => { // new
  try {
    // console.log(req.body.account_id);
    const ladleid = req.body.ladleid;
    console.log(ladleid);
    const transaction = await supplyChainContract.methods.shipToLF_1(ladleid).send({from:arr[1],gasLimit: '6000000'});
    console.log(transaction);
    res.json({ status: 'Ladle sent successfully' })
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }

});

app.post('/receivebyconverter', async (req, res) => { // new
  try {
    const ladleid = req.body.ladleid;
    // console.log(req.body.account_id);
    // Call the smart contract method from receive the product
    const transaction = await supplyChainContract.methods.receiveByConverter(ladleid).send({from:arr[1],gasLimit:'6000000'}); // Replace with the receiver converter's Ethereum address

    res.json({ status: 'Ladle received successfully' });
    console.log(transaction);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }

});


app.post('/shipbylf1', async (req, res) => { // new
  try {
    // console.log(req.query.account_id);
    const ladleid = req.body.ladleid;
    console.log(ladleid);
    const transaction = supplyChainContract.methods.shipToLF_2(ladleid).send({from:arr[2],gasLimit: '6000000'});;
    res.json({ status: 'Ladle sent successfully' })
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }

});

app.post('/receivebylf1', async (req, res) => { // new
  try {
    const { ladleid } = req.body;
    // console.log(req.query.account_id);
    // Call the smart contract method from receive the product
    const transaction = await supplyChainContract.methods.receiveByLF_1(ladleid).send({from:arr[2],gasLimit: '6000000'}); // Replace with the receiver converter's Ethereum address

    res.json({ status: 'Ladle received successfully' });
    console.log(transaction);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }

});


//////////
app.post('/shipbylf2', async (req, res) => { // new
  try {
    console.log(req.query.account_id);
    const { ladleid } = req.body;
    const transaction = await supplyChainContract.methods.shipByRH(ladleid).send({ from: req.query.account_id });
    res.json({ status: 'Ladle sent successfully' })
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }

});

app.post('/receivebylf2', async (req, res) => { // new
  try {
    const { ladleid } = req.body;
    console.log(req.query.account_id);
    // Call the smart contract method from receive the product
    const transaction = await supplyChainContract.methods.receiveByLF_2(ladleid).send({ from: req.query.account_id }); // Replace with the receiver converter's Ethereum address

    res.json({ status: 'Ladle received successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }

});

app.post('/shipbyrh', async (req, res) => { // new
  try {
    console.log(req.query.account_id);
    const { ladleid } = req.body;
    const transaction = await supplyChainContract.methods.shipByRH(ladleid).send({ from: req.query.account_id });
    res.json({ status: 'Ladle sent successfully' })
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }

});

app.post('/receivebyrh', async (req, res) => { // new
  try {
    const { ladleid } = req.body;
    console.log(req.query.account_id);
    // Call the smart contract method from receive the product
    const transaction = await supplyChainContract.methods.receiveByRH(ladleid).send({ from: req.query.account_id }); // Replace with the receiver converter's Ethereum address

    res.json({ status: 'Ladle received successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }

});


app.post('/receivebycasting', async (req, res) => { // new
  try {
    const { ladleid } = req.body;
    console.log(req.query.account_id);
    // Call the smart contract method from receive the product
    const transaction = await supplyChainContract.methods.receiveByCastingMachine(ladleid).send({ from: req.query.account_id }); // Replace with the receiver converter's Ethereum address

    res.json({ status: 'Ladle received successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }

});

/* Ladle Count at each Station */

// // TLC
// app.get('/getLcntatTLC',async (req,res) =>{
//   try{
//     console.log(req.query.account_id);
//     const {transaction, arr} = await supplyChainContract.methods.fetchCLnt(req.query.account_id).send({ from: req.query.account_id });
//     res.json({ status: 'Shipped Count', count: transaction });
//   } catch (error){
//     console.error(error);
//     res.status(500).json({ error: 'Internal server error' });
//   }
// });


// Converter
app.get('/getLcntatConverter',async (req,res) =>{
  try{
    console.log(req.query.account_id);
    const {transaction, arr} = await supplyChainContract.methods.fetchCLnt(req.query.account_id).send({ from: req.query.account_id });
    res.json({ status: 'Shipped Count', count: transaction });
  } catch (error){
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// LF1
app.get('/getLcntatlf1',async (req,res) =>{
  try{
    console.log(req.query.account_id);
    const {transaction, arr} = await supplyChainContract.methods.fetchCLnt(req.query.account_id).send({ from: req.query.account_id });
    res.json({ status: 'Shipped Count', count: transaction });
    console.log(transaction);
  } catch (error){
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// LF2
app.get('/getLcntatlf2',async (req,res) =>{
  try{
    console.log(req.query.account_id);
    const {transaction, arr} = await supplyChainContract.methods.fetchCLnt(req.query.account_id).send({ from: req.query.account_id });
    res.json({ status: 'Shipped Count', count: transaction });
  } catch (error){
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// RH
app.get('/getLcntatrh',async (req,res) =>{
  try{
    console.log(req.query.account_id);
    const {transaction, arr} = await supplyChainContract.methods.fetchCLnt(req.query.account_id).send({ from: req.query.account_id });
    res.json({ status: 'Shipped Count', count: transaction });
  } catch (error){
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Casting_Machine
app.get('/getLcntatCasting',async (req,res) =>{
  try{
    console.log(req.query.account_id);
    const {transaction, arr} = await supplyChainContract.methods.fetchCLnt(req.query.account_id).send({ from: req.query.account_id });
    res.json({ status: 'Shipped Count', count: transaction });
  } catch (error){
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/* */


app.post('/ladlehistory',async (req,res)=>{
  try{
    const ladleid = req.body.ladleid;
    const { a ,b} =  await supplyChainContract.methods.fetchLadleHistory(ladleid).call();
    res.json({ status: 'Shipped Count' });
    console.log(a);
    console.log(b);
  }
  catch(error){
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(8000, () => console.log('listening on port 8000'));