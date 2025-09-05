// GraphQL 查询和变更定义
// 包含所有订阅相关的 GraphQL 操作

/// 获取订阅列表查询
const String getSubscriptionsQuery = r'''
  query GetSubscriptions($userId: UUID!, $isActive: Boolean!) {
    subscriptionsCollection(
      filter: { 
        user_id: { eq: $userId }, 
        is_active: { eq: $isActive } 
      }
      orderBy: { created_at: DescNullsLast }
    ) {
      edges {
        node {
          id
          name
          price
          currency
          billing_cycle
          next_renewal_date
          auto_renewal
          description
          icon_name
          is_active
          created_at
          updated_at
        }
      }
    }
  }
''';

/// 根据 ID 获取单个订阅查询
const String getSubscriptionByIdQuery = r'''
  query GetSubscriptionById($id: UUID!) {
    subscriptionsCollection(filter: { id: { eq: $id } }) {
      edges {
        node {
          id
          name
          price
          currency
          billing_cycle
          next_renewal_date
          auto_renewal
          description
          icon_name
          is_active
          user_id
          created_at
          updated_at
        }
      }
    }
  }
''';

/// 创建订阅变更
const String createSubscriptionMutation = r'''
  mutation CreateSubscription($input: SubscriptionsInsertInput!) {
    insertIntoSubscriptionsCollection(objects: [$input]) {
      records {
        id
        name
        price
        currency
        billing_cycle
        next_renewal_date
        auto_renewal
        description
        icon_name
        is_active
        created_at
        updated_at
      }
    }
  }
''';

/// 更新订阅变更
const String updateSubscriptionMutation = r'''
  mutation UpdateSubscription($id: UUID!, $input: SubscriptionsUpdateInput!) {
    updateSubscriptionsCollection(
      filter: { id: { eq: $id } }
      set: $input
    ) {
      records {
        id
        name
        price
        currency
        billing_cycle
        next_renewal_date
        auto_renewal
        description
        icon_name
        is_active
        updated_at
      }
    }
  }
''';

/// 删除订阅变更
const String deleteSubscriptionMutation = r'''
  mutation DeleteSubscription($id: UUID!) {
    deleteFromSubscriptionsCollection(filter: { id: { eq: $id } }) {
      records {
        id
      }
    }
  }
''';

/// 搜索订阅查询
const String searchSubscriptionsQuery = r'''
  query SearchSubscriptions(
    $userId: UUID!, 
    $searchTerm: String!, 
    $isActive: Boolean!,
    $limit: Int,
    $offset: Int
  ) {
    subscriptionsCollection(
      filter: { 
        user_id: { eq: $userId },
        is_active: { eq: $isActive },
        or: [
          { name: { ilike: $searchTerm } },
          { description: { ilike: $searchTerm } }
        ]
      }
      orderBy: { created_at: DescNullsLast }
      first: $limit
      offset: $offset
    ) {
      edges {
        node {
          id
          name
          price
          currency
          billing_cycle
          next_renewal_date
          auto_renewal
          description
          icon_name
          is_active
          created_at
          updated_at
        }
      }
      pageInfo {
        hasNextPage
        hasPreviousPage
        startCursor
        endCursor
      }
    }
  }
''';

/// 获取即将到期的订阅查询
const String getUpcomingSubscriptionsQuery = r'''
  query GetUpcomingSubscriptions($userId: UUID!, $daysAhead: Int!) {
    subscriptionsCollection(
      filter: { 
        user_id: { eq: $userId },
        is_active: { eq: true },
        next_renewal_date: { 
          lte: "now() + interval '$daysAhead days'"
        }
      }
      orderBy: { next_renewal_date: AscNullsLast }
    ) {
      edges {
        node {
          id
          name
          price
          currency
          billing_cycle
          next_renewal_date
          auto_renewal
          description
          icon_name
          created_at
          updated_at
        }
      }
    }
  }
''';

/// 获取订阅统计查询
const String getSubscriptionStatsQuery = r'''
  query GetSubscriptionStats($userId: UUID!) {
    subscriptionsCollection(
      filter: { 
        user_id: { eq: $userId }, 
        is_active: { eq: true } 
      }
    ) {
      edges {
        node {
          price
          billing_cycle
          currency
        }
      }
    }
  }
''';

/// 按货币分组统计查询
const String getSubscriptionStatsByCurrencyQuery = r'''
  query GetSubscriptionStatsByCurrency($userId: UUID!) {
    subscriptionsCollection(
      filter: { 
        user_id: { eq: $userId }, 
        is_active: { eq: true } 
      }
    ) {
      edges {
        node {
          currency
          price
          billing_cycle
        }
      }
    }
  }
''';

/// 批量更新订阅状态变更
const String batchUpdateSubscriptionsMutation = r'''
  mutation BatchUpdateSubscriptions($ids: [UUID!]!, $input: SubscriptionsUpdateInput!) {
    updateSubscriptionsCollection(
      filter: { id: { in: $ids } }
      set: $input
    ) {
      records {
        id
        is_active
        updated_at
      }
    }
  }
''';

/// 订阅实时更新订阅
const String subscribeToSubscriptionUpdates = r'''
  subscription SubscribeToSubscriptionUpdates($userId: UUID!) {
    subscriptionsCollection(
      filter: { user_id: { eq: $userId } }
    ) {
      id
      name
      price
      currency
      billing_cycle
      next_renewal_date
      auto_renewal
      description
      icon_name
      is_active
      created_at
      updated_at
    }
  }
''';

/// 获取月度历史数据查询
const String getMonthlyHistoryQuery = r'''
  query GetMonthlyHistory($userId: UUID!, $months: Int!) {
    monthlyHistoryCollection(
      filter: { user_id: { eq: $userId } }
      orderBy: { month: DescNullsLast }
      first: $months
    ) {
      edges {
        node {
          id
          month
          total_amount
          currency_totals
          subscription_count
          user_id
          created_at
        }
      }
    }
  }
''';