import React, { Component } from "react";
import {
  Table,
  Button,
  Modal,
  Form,
  InputNumber,
  Input,
  message,
  Popconfirm
} from "antd";

import EditableCell from "./EditableCell";

const gas = 1000000;

const FormItem = Form.Item;

const columns = [
  {
    title: "地址",
    dataIndex: "address",
    key: "address"
  },
  {
    title: "薪水",
    dataIndex: "salary",
    key: "salary"
  },
  {
    title: "上次支付",
    dataIndex: "lastPaidDay",
    key: "lastPaidDay"
  },
  {
    title: "操作",
    dataIndex: "",
    key: "action"
  }
];

class EmployeeList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      employees: [],
      showModal: false
    };

    columns[1].render = (text, record) => (
      <EditableCell
        value={text}
        onChange={this.updateEmployee.bind(this, record.address)}
      />
    );

    columns[3].render = (text, record) => (
      <Popconfirm
        title="你确定删除吗?"
        onConfirm={() => this.removeEmployee(record.address)}
      >
        <a href="#">Delete</a>
      </Popconfirm>
    );
  }

  componentDidMount() {
    const { payroll, account } = this.props;
    payroll.getEmployerInfo
      .call({
        from: account
      })
      .then(result => {
        const employeeCount = result[2].toNumber();

        if (employeeCount === 0) {
          this.setState({ loading: false });
          return;
        }

        this.loadEmployees(employeeCount);
      });
  }

  async loadEmployees(employeeCount) {
    const { payroll, account, web3 } = this.props;
    const infoPromises = [...Array(employeeCount).keys()].map(i =>
      payroll.getEmployeeInfo(i, { from: account })
    );
    const infoResults = await Promise.all(infoPromises);
    this.setState({
      employees: infoResults.map(info => ({
        key: info[0],
        address: info[0],
        salary: web3.fromWei(info[1].toNumber()),
        lastPaidDay: new Date(info[2].toNumber() * 1000).toString()
      })),
      loading: false
    });
  }

  async addEmployee() {
    const { address, salary: salaryInEther } = this.state;
    const { payroll, account } = this.props;
    this.setState({ showModal: false });
    try {
      await payroll.addEmployee(address, salaryInEther, { from: account, gas });
      this.setState({
        employees: this.state.employees.concat([
          {
            key: address,
            address,
            salary: salaryInEther,
            lastPaidDay: new Date().toString()
          }
        ])
      });
    } catch (error) {
      console.log(error);
      alert("Failed to add employee: ", error);
    }
  }

  async updateEmployee(address, salary) {
    const { payroll, account } = this.props;
    const employee = this.state.employees.find(e => e.address === address);
    if (employee.salary === salary) {
      return;
    }
    try {
      await payroll.updateEmployee(address, salary, { from: account, gas });
      employee.salary = salary;
      this.setState({ employees: this.state.employees });
    } catch (error) {
      console.log(error);
      alert("Failed to update employee: ", error);
    }
  }

  async removeEmployee(address) {
    const { payroll, account } = this.props;
    try {
      await payroll.removeEmployee(address, { from: account, gas });
      this.setState({
        employees: this.state.employees.filter(e => e.address != address)
      });
    } catch (error) {
      console.log(error);
      alert("Failed to remove employee: ", error);
    }
  }

  renderModal() {
    return (
      <Modal
        title="增加员工"
        visible={this.state.showModal}
        onOk={this.addEmployee.bind(this)}
        onCancel={() => this.setState({ showModal: false })}
      >
        <Form>
          <FormItem label="地址">
            <Input
              onChange={ev => this.setState({ address: ev.target.value })}
            />
          </FormItem>

          <FormItem label="薪水">
            <InputNumber
              min={1}
              onChange={salary => this.setState({ salary })}
            />
          </FormItem>
        </Form>
      </Modal>
    );
  }

  render() {
    const { loading, employees } = this.state;
    return (
      <div>
        <Button
          type="primary"
          onClick={() => this.setState({ showModal: true })}
        >
          增加员工
        </Button>

        {this.renderModal()}

        <Table loading={loading} dataSource={employees} columns={columns} />
      </div>
    );
  }
}

export default EmployeeList;
