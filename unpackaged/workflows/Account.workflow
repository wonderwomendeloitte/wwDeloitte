<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Verification_Code_as_email</fullName>
        <description>Send Verification Code as email</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>WW_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_OTP</template>
    </alerts>
    <fieldUpdates>
        <fullName>reset_send_code</fullName>
        <field>WW_Send_Code__c</field>
        <literalValue>0</literalValue>
        <name>reset send code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Send OTP</fullName>
        <actions>
            <name>Send_Verification_Code_as_email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>reset_send_code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.WW_Send_Code__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>sends otp when they request otp in email</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
