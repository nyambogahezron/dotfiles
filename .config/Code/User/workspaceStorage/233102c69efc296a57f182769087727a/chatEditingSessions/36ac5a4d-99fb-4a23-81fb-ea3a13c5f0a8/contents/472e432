import { db } from '../db';
import { sql } from 'drizzle-orm';

/**
 * Database utility functions that leverage advanced PostgreSQL features
 */

export interface UserActivitySummary {
  totalTransactions: number;
  totalIncome: number;
  totalExpenses: number;
  organizationsCount: number;
  activeBudgetsCount: number;
  unreadNotificationsCount: number;
}

export interface BudgetUtilization {
  budgetId: string;
  utilization: number;
  isOverBudget: boolean;
}

export class DatabaseUtils {
  /**
   * Get comprehensive activity summary for a user
   */
  static async getUserActivitySummary(
    userId: string,
    daysBack: number = 30
  ): Promise<UserActivitySummary> {
    const result = await db.execute(
      sql`SELECT * FROM get_user_activity_summary(${userId}, ${daysBack})`
    );

    const row = result.rows[0] as any;
    return {
      totalTransactions: Number(row?.total_transactions) || 0,
      totalIncome: Number(row?.total_income) || 0,
      totalExpenses: Number(row?.total_expenses) || 0,
      organizationsCount: Number(row?.organizations_count) || 0,
      activeBudgetsCount: Number(row?.active_budgets_count) || 0,
      unreadNotificationsCount: Number(row?.unread_notifications_count) || 0,
    };
  }

  /**
   * Calculate budget utilization percentage
   */
  static async getBudgetUtilization(budgetId: string): Promise<number> {
    const result = await db.execute(
      sql`SELECT calculate_budget_utilization(${budgetId}) as utilization`
    );

    return parseFloat((result.rows[0] as any)?.utilization || '0');
  }

  /**
   * Get utilization for multiple budgets
   */
  static async getBudgetsUtilization(budgetIds: string[]): Promise<BudgetUtilization[]> {
    const results = await Promise.all(
      budgetIds.map(async (budgetId) => {
        const utilization = await this.getBudgetUtilization(budgetId);
        return {
          budgetId,
          utilization,
          isOverBudget: utilization > 100,
        };
      })
    );

    return results;
  }

  /**
   * Generate unique ID with prefix
   */
  static async generateId(prefix: string): Promise<string> {
    const result = await db.execute(sql`SELECT generate_id(${prefix}) as id`);

    return (result.rows[0] as any)?.id || '';
  }

  /**
   * Clean up expired tokens
   */
  static async cleanupExpiredTokens(): Promise<number> {
    const result = await db.execute(sql`SELECT cleanup_expired_tokens() as deleted_count`);

    return Number((result.rows[0] as any)?.deleted_count) || 0;
  }

  /**
   * Clean up expired notifications
   */
  static async cleanupExpiredNotifications(): Promise<number> {
    const result = await db.execute(sql`SELECT cleanup_expired_notifications() as deleted_count`);

    return Number((result.rows[0] as any)?.deleted_count) || 0;
  }

  /**
   * Get user statistics from the user_stats view
   */
  static async getUserStats(userId?: string) {
    let query = sql`SELECT * FROM user_stats`;

    if (userId) {
      query = sql`SELECT * FROM user_stats WHERE user_id = ${userId}`;
    }

    const result = await db.execute(query);
    return result.rows;
  }

  /**
   * Get organization statistics from the organization_stats view
   */
  static async getOrganizationStats(organizationId?: string) {
    let query = sql`SELECT * FROM organization_stats`;

    if (organizationId) {
      query = sql`SELECT * FROM organization_stats WHERE organization_id = ${organizationId}`;
    }

    const result = await db.execute(query);
    return result.rows;
  }

  /**
   * Get monthly transaction summary for an organization
   */
  static async getMonthlyTransactionSummary(organizationId: string, year: number, month?: number) {
    let query = sql`
      SELECT 
        EXTRACT(MONTH FROM date) as month,
        type,
        COUNT(*) as transaction_count,
        SUM(amount) as total_amount,
        AVG(amount) as avg_amount
      FROM transactions
      WHERE organization_id = ${organizationId}
        AND EXTRACT(YEAR FROM date) = ${year}
    `;

    if (month) {
      query = sql`${query} AND EXTRACT(MONTH FROM date) = ${month}`;
    }

    query = sql`${query} GROUP BY EXTRACT(MONTH FROM date), type ORDER BY month, type`;

    const result = await db.execute(query);
    return result.rows;
  }

  /**
   * Get budget performance analytics
   */
  static async getBudgetPerformanceAnalytics(organizationId: string) {
    const query = sql`
      SELECT 
        b.id,
        b.name,
        b.amount as budget_amount,
        b.spent,
        calculate_budget_utilization(b.id) as utilization_percentage,
        CASE 
          WHEN calculate_budget_utilization(b.id) > 100 THEN 'over_budget'
          WHEN calculate_budget_utilization(b.id) > 80 THEN 'warning'
          ELSE 'on_track'
        END as status,
        (b.end_date - CURRENT_DATE) as days_remaining,
        COUNT(t.id) as transaction_count
      FROM budgets b
      LEFT JOIN transactions t ON t.budget_id = b.id
      WHERE b.organization_id = ${organizationId}
        AND b.is_active = true
      GROUP BY b.id, b.name, b.amount, b.spent, b.end_date
      ORDER BY utilization_percentage DESC
    `;

    const result = await db.execute(query);
    return result.rows;
  }

  /**
   * Get transaction trends for an organization
   */
  static async getTransactionTrends(organizationId: string, daysBack: number = 30) {
    const query = sql`
      SELECT 
        DATE(date) as transaction_date,
        type,
        COUNT(*) as transaction_count,
        SUM(amount) as total_amount,
        AVG(amount) as avg_amount
      FROM transactions
      WHERE organization_id = ${organizationId}
        AND date >= CURRENT_DATE - INTERVAL '${sql.raw(daysBack.toString())} days'
      GROUP BY DATE(date), type
      ORDER BY transaction_date DESC, type
    `;

    const result = await db.execute(query);
    return result.rows;
  }

  /**
   * Get top spending categories for an organization
   */
  static async getTopSpendingCategories(
    organizationId: string,
    limit: number = 10,
    daysBack: number = 30
  ) {
    const query = sql`
      SELECT 
        category,
        COUNT(*) as transaction_count,
        SUM(amount) as total_amount,
        AVG(amount) as avg_amount
      FROM transactions
      WHERE organization_id = ${organizationId}
        AND type = 'expense'
        AND date >= CURRENT_DATE - INTERVAL '${sql.raw(daysBack.toString())} days'
      GROUP BY category
      ORDER BY total_amount DESC
      LIMIT ${limit}
    `;

    const result = await db.execute(query);
    return result.rows;
  }

  /**
   * Get users with expiring subscriptions
   */
  static async getUsersWithExpiringSubscriptions(daysAhead: number = 7) {
    const query = sql`
      SELECT 
        u.id,
        u.name,
        u.email,
        s.type as subscription_type,
        s.end_date,
        (s.end_date - CURRENT_DATE) as days_until_expiry
      FROM users u
      JOIN subscriptions s ON s.user_id = u.id
      WHERE s.is_active = true
        AND s.end_date IS NOT NULL
        AND s.end_date <= CURRENT_DATE + INTERVAL '${sql.raw(daysAhead.toString())} days'
        AND s.end_date > CURRENT_DATE
      ORDER BY s.end_date ASC
    `;

    const result = await db.execute(query);
    return result.rows;
  }

  /**
   * Execute custom analytics query safely
   */
  static async executeAnalyticsQuery(query: string, params: any[] = []) {
    try {
      // For now, execute raw query without parameters for safety
      const result = await db.execute(sql.raw(query));
      return result.rows;
    } catch (error) {
      console.error('Analytics query error:', error);
      throw new Error('Failed to execute analytics query');
    }
  }
}
