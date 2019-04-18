var AWS = require("aws-sdk");

exports.handler = async (event) => {
  var ec2 = new AWS.EC2();
  var autoscaling = new AWS.AutoScaling();

  await ec2.modifyInstanceAttribute({
    InstanceId: event.detail.EC2InstanceId,
    SourceDestCheck: {
      Value: false
    }
  }).promise();

  await autoscaling.completeLifecycleAction({
    AutoScalingGroupName: event.detail.AutoScalingGroupName,
    LifecycleActionResult: "CONTINUE",
    LifecycleActionToken: event.detail.LifecycleActionToken,
    LifecycleHookName: event.detail.LifecycleHookName
  }).promise();

  return "done";
};
