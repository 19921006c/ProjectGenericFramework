# ProjectGenericFramework
This is a Project Generic Framework
这是一个通用的，TabBarController + NavigationController + 自定义的TabBar 框架。简单易用
1. 设置好TabBarController
2. 设置好Navigation pop
3. 自定义TabBar
4. 不需要中间的自定义btn, 只需要注释掉MainTabBarController类中两行代码

tabBar.customDelegate = self;

[self setValue:tabBar forKey:@"tabBar"];
