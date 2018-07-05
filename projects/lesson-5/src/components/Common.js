import React, { Component } from 'react'
import {Card, Col, Row } from 'antd';

class Common extends Component {
    constructor(props) {
        super(props);

        this.state = {};
    }

    componentDidMount() {
        this.checkInfo();
    }

    checkInfo = () => {
        const {payroll, account, web3} = this.props;
        payroll.checkInfo.call({
            from: account,
        }).then((result) => {
            this.setState({
                balance: web3.fromWei(result[0].toNumber()),
                runway: result[1].toNumber,
                employeeCount: result[2].toNumber()
            })
        });
    }

    // componentDidMount() {
    //     const {payroll, web3, account} = this.props;
    //     payroll.getInfo.call({
    //         from: account,
    //     }).then((result) => {
    //         this.setState({
    //             balance: web3.fromWei(result[0].toNumber()),
    //         })
    //     });
    // }

    render() {
        const {runway, balance, employeeCount} = this.state;
        return (
            // <div>
            //     <h2>tongyongxinxi</h2>
            //     <p>heyunjine: {balance}</p>
            //     <p>yuangongrenshu: {employeeCount}</p>
            //     <p>kezhifucishu: {runway}</p>
            // </div>
            <div>
            <h2>general</h2>
            <Row gutter = {16}>
                <Col span={8}>
                    <Card title="heyuejine">{balance}Ether</Card>
                </Col>
                <Col span={8}>
                    <Card title="yuangongrenshu">{employeeCount}</Card>
                </Col>
                <Col span={8}>
                    <Card title="kezhifucishu">{runway}</Card>
                </Col>
            </Row>
            </div>
        )

    }
}

export default Common