import React, { Component } from 'react'
import {Card, Col, Row, Layout, Alert, message, Button} from 'antd';

import Common from './Common';

class Employee extends Component {
    constructor (props) {
        super(props);
        this.state = {};
    }

    componentDidMount() {
        this.checkEmployee();
    }

    checkEmployee = () => {
        const {payroll, employee, web3} = this.props;
        payroll.employees.call(employee, {
            from: employee,
        }).then((result) => {
            this.setState({
                salary: web3.fromWei(result[1].toNumber()),
                lastPaidDate: new Date(result[2].toNumber() * 1000)
            });
        });

        web3.eth.getBalance(account, (err, result) => {
            this.setState({
                balance: web3.fromWei(result.toNumber())
            });
        });
    }

    getPaid = () => {
        const {payroll, employee} = this.props;
        payroll.getPaid({
            from: employee,
        }).then((result) => {
            alert('You have been paid');
        });
    }

    renderContent() {
        const {salary, lastPaidDate, balance} = this.state;
        // const {employee} = this.props;
        if (!salary || salary === '0') {
            return <Alert message="you are not employee" type="error" showIcon />;
        }

        return (
            // <div>
            //     <h2>yuangong</h2>
            //     { !salary || salary === '0' ?
            //         <p>you are not employee now</p> :
            //         (
            //             <div>
            //                 <p>salary: {salary}</p>
            //                 <p>last paydare: {lastPaidDate.toString()}</p>
            //                 <button type="button" className="pure-button" onClick={this.getPaid}> getPaid </button>

            //             </div>
            //         )
            //     }
            // </div>
            <div>
                <Row gutter = {16}>
                <Col span={8}>
                    <Card title="xinshui">{salary}Ether</Card>
                </Col>
                <Col span={8}>
                    <Card title="shangcizhifu">{lastPaidDate}</Card>
                </Col>
                <Col span={8}>
                    <Card title="zhanghaojine">{balance} Ether</Card>
                </Col>
            </Row>

            <Button type="primary" icon="bank"
            onClick={this.getPaid}> huode choulao </Button>
            </div>
        );
    }

    render() {
        const {account, payroll, web3} = this.props;

        return (
            <Layout style = {{padding: '0 24px', background: '#fff'}}>
            <Common account={account} payroll={payroll} web3={web3} />
            <h2>gerenxinxi</h2>
            {this.renderContent()}
            </Layout>
        )
    }
}

export default Employee