import launch
from launch_ros.actions import ComposableNodeContainer
from launch_ros.descriptions import ComposableNode
from launch.substitutions import LaunchConfiguration as LaunchConfig
from launch.actions import DeclareLaunchArgument as LaunchArg
from ament_index_python.packages import get_package_share_directory

camera_params = {
    'debug': False,
    'dump_node_map': False,
    'gain_auto': 'Off',
    'gain': 0,
    'exposure_auto': 'Off',
    'exposure_time': 15000,
    'line2_selector': 'Line2',
    'line2_v33enable': False,
    'line3_selector': 'Line3',
    'line3_linemode': 'Input',
    'trigger_selector': 'FrameStart',
    'trigger_mode': 'On',
    'trigger_source': 'Line3',
    'trigger_delay': 9,
    'trigger_overlap': 'ReadOut',
    }

def generate_launch_description():
    """create synchronized stereo camera."""
    flir_dir = get_package_share_directory('flir_spinnaker_ros2')
    config_dir = get_package_share_directory('flir_spinnaker_ros2') + '/config/'
    container = ComposableNodeContainer(
            name='stereo_camera_container',
            namespace='',
            package='rclcpp_components',
            executable='component_container',
            composable_node_descriptions=[
                ComposableNode(
                    package='flir_spinnaker_ros2',
                    plugin='flir_spinnaker_ros2::FlirSpinnakerROS2',
                    name=LaunchConfig('cam_0_name'),
                    parameters=[camera_params,
                        {'name': LaunchConfig('cam_0_name'),
                         'parameter_file': config_dir + 'blackfly_s.cfg',
                         'serial_number': '20435008'}]
                ),
                ComposableNode(
                    package='flir_spinnaker_ros2',
                    plugin='flir_spinnaker_ros2::FlirSpinnakerROS2',
                    name='cam_1',
                    parameters=[camera_params,
                        {'name': LaunchConfig('cam_1_name'),
                         'parameter_file': config_dir + 'blackfly_s.cfg',
                         'serial_number': '20415937'}]
                ),
                ComposableNode(
                    package='cam_sync_ros2',
                    plugin='cam_sync_ros2::CamSync',
                    name='sync',
                    parameters=[]
                )
            ],
            output='screen',
    )
    name_0_arg = LaunchArg('cam_0_name', default_value=['cam_0'], description='name of camera 0')
    name_1_arg = LaunchArg('cam_1_name', default_value=['cam_1'], description='name of camera 1')
    return launch.LaunchDescription([name_0_arg, name_1_arg, container])
