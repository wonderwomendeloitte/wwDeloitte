<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ContactSend_Verification_Code_as_email</fullName>
        <description>Send Verification Code as email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_OTP</template>
    </alerts>
    <fieldUpdates>
        <fullName>reset_send_code</fullName>
        <field>WW_ConSend_Code__c</field>
        <literalValue>0</literalValue>
        <name>reset send code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Send verification code</fullName>
        <actions>
            <name>ContactSend_Verification_Code_as_email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>reset_send_code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.WW_Send_Code__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
