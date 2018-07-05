import React, { Component } from 'react'
import { Layout, Menu, Alert } from 'antd';

import Fund from './Fund';
import EmployeeList from './EmployeeList';

const { Content, Sider } = Layout;

class Employer extends Component {
  constructor(props) {
    super(props);

    this.state = {
      mode: 'fund'
    };
  }

  /*
  addFund = () => {
    const { payroll, employer, web3} = this.props;
    payroll.addFund({
      from: employer,
      value: web3.toWei(this.fundInput.value)
    });
  }

  addEmployee = () => {
    const { payroll, employer } = this.props;
    payroll.addEmployee(this.emloyeeInput.value, parseInt(this.salaryInput.value), {
      from: employer, 
      gas: 1000000
    }).then((result) => {
      alert('success');
    });
  }

  updateEmployee = () => {
    const { payroll, employer } = this.props;
    payroll.updateEmployee(this.emloyeeInput.value, parseInt(this.salaryInput.value), {
      from: employer, 
      gas: 1000000
    }).then((result) => {
      alert('success');
    });
  }

  removeEmployee = () => {
    const { payroll, employer } = this.props;
    payroll.removeEmployee(this.emloyeeInput.value, {
      from: employer, 
      gas: 1000000
    }).then((result) => {
      alert('success');
    });
  }
  */
  componentDidMount() {
    const { account, payroll } = this.props;
    payroll.owner.call({
      from: account
    }).then((result) => {
      this.setState({
        owner: result
      });
    })
  }

  onSelectTab = ({key}) => {
    this.setState({
      mode: key
    });
  }

  renderContent = () => {
    const { account, payroll, web3 } = this.props;
    const { mode, owner } = this.state;

    if (owner !== account) {
      return <Alert message="你没有权限" type="error" showIcon />;
    }

    switch(mode) {
      case 'fund':
        return <Fund account={account} payroll={payroll} web3={web3} />
      case 'employees':
        return <EmployeeList account={account} payroll={payroll} web3={web3} />
    }
  }

  render() {
    return (
      /*
      <div>
        <h2>Employer</h2>
        <form className="pure-form pure-form-stacked">
          <fieldset>
            <legend>Add fund</legend>
            <label>fund</label>
            <input
              type="text"
              placeholder="fund"
              ref={(input) => {this.fundInput = input;}}/>

              <button type="button" className="pure-button" onClick={this.addFund}>Add</button>
            </fieldset>
        </form>
        
        <form className="pure-form pure-form-stacked">
          <fieldset>
            <legend>Add/Upgrade Employee</legend>

            <label>employee id</label>
            <input
              type="text"
              placeholder="employee"
              ref={(input) => {this.employeeInput = input;}}/>

            <label>salary</label>
            <input
              type="text"
              placeholder="salary"
              ref={(input) => {this.salaryInput = input;}}/>

              <button type="button" className="pure-button" onClick={this.addEmployee}>Add</button>
              <button type="button" className="pure-button" onClick={this.updateEmployee}>Update</button>
            </fieldset>
        </form>

        <form className="pure-form pure-form-stacked">
          <fieldset>
            <legend>Remove Employee</legend>
            <label>employee id</label>
            <input
              type="text"
              placeholder="employee"
              ref={(input) => {this.removeEmployeeInput = input;}}/>

              <button type="button" className="pure-button" onClick={this.removeEmployee}>Remove</button>
            </fieldset>
        </form>
      </div>
      */

      <Layout style={{ padding: '24px 0', background: '#fff'}}>
        <Sider width={200} style={{ background: '#fff' }}>
          <Menu
            mode="inline"
            defaultSelectedKeys={['fund']}
            style={{ height: '100%' }}
            onSelect={this.onSelectTab}
          >
            <Menu.Item key="fund">合约信息</Menu.Item>
            <Menu.Item key="employees">雇员信息</Menu.Item>
          </Menu>
        </Sider>
        <Content style={{ padding: '0 24px', minHeight: 280 }}>
          {this.renderContent()}
        </Content>
      </Layout>
    );
  }
}

export default Employer