import React, { Component } from 'react'
import PayrollContract from '../build/contracts/Payroll.json'
import getWeb3 from './utils/getWeb3'

import { Layout, Menu, Spin, Alert } from 'antd';

// import Accounts from './components/Accounts';
import Employer from './components/Employer';
import Employee from './components/Employee';
// import Common from './components/Common';

// import './css/oswald.css'
// import './css/open-sans.css'
// import './css/pure-min.css'
import 'antd/dist/antd.css';
import './App.css'

const { Header, Content, Footer } = Layout;

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      storageValue: 0,
      web3: null,
      mode: 'employer'
    }
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      this.setState({
        web3: results.web3
      })

      // Instantiate contract once web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
  }

  instantiateContract() {
    /*
     * SMART CONTRACT EXAMPLE
     *
     * Normally these functions would be called in the context of a
     * state management library, but for convenience I've placed them here.
     */

    const contract = require('truffle-contract')
    const Payroll = contract(PayrollContract)
    Payroll.setProvider(this.state.web3.currentProvider)

    // Declaring this for later so we can chain functions on SimpleStorage.
    var PayrollInstance
    var onSelectAccount

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      this.setState({
        accounts,
        selectedAccount: accounts[0]
      });
      Payroll.deployed().then((instance) => {
        PayrollInstance = instance
        this.setState({
          payroll: instance
        });
      })

      onSelectAccount = (ev) => {
        this.setState({
          selectedAccount: ev.target.text
        });
      }

      onSelectTab = ({key}) => {
        this.setState({
          mode: key
        });
      }

      renderContent = () => {
        const {account, payroll, web3, mode } = this.state;

        if (!payroll) {
          return <Spin tip="Loading..." />;
        }
        switch (mode) {
          case 'emplolyer':
            return <Employer account={account} payroll={payroll} web3={web3} />
          case 'employee':
            return <Employee account={account} payroll={payroll} web3={web3} />
          default:
            return <Alert message="select a mode" type="info" showIcon />
        }
      }

      // simpleStorage.deployed().then((instance) => {
      //   simpleStorageInstance = instance

      //   // Stores a given value, 5 by default.
      //   return simpleStorageInstance.set(12, {from: accounts[0]})
      // }).then((result) => {
      //   // Get the value from the contract to prove it worked.
      //   return simpleStorageInstance.get.call(accounts[0])
      // }).then((result) => {
      //   // Update state with the result.
      //   return this.setState({ storageValue: result.c[0] })
      // })
    })
  }

  render() {
    const {selectedAccount, accounts, payroll, web3} = this.state;
    if (!accounts) {
      return <div>Loading</div>;
    }
    return (
      // <div className="App">
      //   <nav className="navbar pure-menu pure-menu-horizontal">
      //       <a href="#" className="pure-menu-heading pure-menu-link">Payroll</a>
      //   </nav>

      //   <main className="container">
      //     <div className="pure-g">
      //       <div className="pure-u-1-3">
      //         <Accounts accounts={accounts} onSelectAccount={this.onSelectAccount} />
      //       </div>
      //       <div className="pure-u-2-3">
      //       {
      //         selectedAccount === accounts[0] ?
      //         <Employer employer = {selectedAccount} payroll={payroll} web3={web3} /> :
      //         <Employee employee = {selectedAccount} payroll={payroll} web3={web3} />
      //       }
      //       {payroll && <Common account={selectedAccount} payroll={payroll} web3={web3} />}
      //       </div>
          
      //     </div>
      //   </main>
      // </div>
      <Layout>
        <Header className="header">
        <div className="logo">blockchain system</div>
        <Menu theme="dark" mode="horizontal" defaultSelectedKeys={['employer']}
        style={{lineHeight: '64px'}}
        onSelect = {this.onSelectTab}>
        <Menu.Item key="employer">employer</Menu.Item>
        <Menu.Item key="employee">employee</Menu.Item>
        </Menu>
        <Content style={{padding: '0 50px' }}>
          <Layout style={{padding: '24px 0', background: '#fff', minHeight: 20}}>
          {this.renderContent()}
          </Layout>
        </Content>
        <Footer style={{textAlign: 'center'}}>
        payroll @2017
        </Footer>
      </Layout>
    );
  }
}

export default App
