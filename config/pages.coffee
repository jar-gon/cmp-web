module.exports = [
  {
    key: 'index'
    label: '首页'
    next: [
      { name: 'index', label: '首页', link: '/' }
    ]
  }

  {
    key: 'trial'
    label: '申请试用'
    next: [
      { name: 'trial', label: '申请试用' }
    ]
  }

  {
    key: 'feature'
    label: '云桥特色'
    next: [
      { name: 'feature-fund', label: '计费和成本管理' }
      { name: 'feature-found', label: '自建云市场' }
      { name: 'feature-deliver', label: '应用交付' }
      { name: 'feature-capture', label: '高效获客' }
    ]
  }
]
